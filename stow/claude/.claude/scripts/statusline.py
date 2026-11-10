#!/usr/bin/env python3
"""Claude Code statusline (settings.json -> statusLine), needs a nerd font.

Claude Code runs this after each message update, passing a JSON payload on stdin
(schema: https://code.claude.com/docs/en/statusline). Two lines, each with a
left and a right-aligned part (width from $COLUMNS, set by Claude Code):

  󰚩 Opus 5.5 󰓅 high · ( 63k  5.2k  1.2k) 󰓾 91%            dotfiles  main · +12 -3
  󰍛 ▰▰▰▰▰▰▰▱▱▱▱▱▱▱▱▱ 34% 68k/200k [󰒓 12k  25k  1k 󰍡 30k]    󰥔 5h 2% 󰑐 4h40m · 󰃭 7d 82% 󰑐 3d5h

Line 1: last request tokens: cache reads (), fresh input (), output (),
then the session's prompt cache hit rate (󰓾).

Line 2: the context bar is split like /context: system prompt (󰒓), built-in
tools (), MCP tools (󰐱), memory files (), messages (󰍡). That split isn't in
the payload, so it's estimated from the transcript (see ContextBreakdown): the
system prompt and tool definitions are logged there, and their sizes in chars
are scaled to tokens using the first request's real token count. Messages are
the rest of the used tokens. Use /context when the exact numbers matter.

Rate limits (`rate_limits`) only exist for Pro/Max logins, after the first API
response. The 5h window is also cached to ~/.cache/claude/usage as
"<used_percent> <resets_at_epoch>" for the tmux status bar
(~/.config/tmux/bin/claude-usage.sh).
"""

import json
import os
import re
import subprocess
import sys
import time

# Columns kept free on the right: Claude Code pads the row and shows its own
# notifications there. Raise it if the right part wraps or gets cut.
RIGHT_MARGIN = 4
BAR_WIDTH = 16
CACHE_DIR = os.path.expanduser("~/.cache/claude")
STATE_VERSION = 2  # bump when ContextBreakdown's cached state changes shape

RESET = "\033[0m"


def fg(n):
    return f"\033[38;5;{n}m"


GREY, BLUE, CYAN, MAGENTA, GREEN, YELLOW, RED, ORANGE, PURPLE = (
    fg(245), fg(75), fg(80), fg(176), fg(114), fg(221), fg(203), fg(215), fg(141)
)

ICON = {
    "model": "\U000f06a9",  # 󰚩
    "effort": "\U000f04c5",  # 󰓅
    "fast": "\U000f140b",  # 󱐋
    "dir": "",  #
    "branch": "",  #
    "ctx": "\U000f035b",  # 󰍛
    "cached": "",  #  cache reads: cheap and fast
    "fresh": "",  #  new input sent
    "out": "",  #  output received
    "hit": "\U000f04fe",  # 󰓾 cache hit rate
    "5h": "\U000f0954",  # 󰥔
    "7d": "\U000f00ed",  # 󰃭
    "reset": "\U000f0450",  # 󰑐
}
SEP = f" {GREY}·{RESET} "

# Context categories, in bar order: (key, icon, color)
CATEGORIES = (
    ("system", "\U000f0493", GREY),  # 󰒓
    ("tools", "", BLUE),  #
    ("mcp", "\U000f0431", CYAN),  # 󰐱
    ("memory", "", PURPLE),  #
    ("messages", "\U000f0361", ORANGE),  # 󰍡
)


def level_color(pct):
    return GREEN if pct < 50 else YELLOW if pct < 80 else RED


def tokens(n):
    n = n or 0
    if n >= 1_000_000:
        return f"{n / 1_000_000:.1f}M".replace(".0M", "M")
    if n >= 1000:
        return f"{n / 1000:.0f}k" if n >= 10_000 else f"{n / 1000:.1f}k"
    return str(round(n))


def duration(secs):
    secs = max(0, int(secs))
    d, h, m = secs // 86400, secs % 86400 // 3600, secs % 3600 // 60
    if d:
        return f"{d}d{h}h"
    if h:
        return f"{h}h{m:02d}m"
    return f"{m}m"


ANSI_RE = re.compile(r"\033\[[0-9;]*m")


def visible_len(s):
    return len(ANSI_RE.sub("", s))


def align(left, right):
    try:
        cols = int(os.environ.get("COLUMNS", ""))
    except ValueError:
        cols = 0
    gap = cols - RIGHT_MARGIN - visible_len(left) - visible_len(right)
    if not right:
        return left
    return left + " " * max(gap, 3) + right


class ContextBreakdown:
    """Estimate /context's categories from the session transcript (JSONL).

    The transcript logs each new request shape (system prompt blocks + tool
    definitions), the extra system/user blocks of the first request (the rest of
    the system prompt, CLAUDE.md / memory reminders) and every response's usage.
    The first response's input tokens cover exactly that first request, which
    gives the chars -> tokens ratio. This format is internal to Claude Code, so
    anything unexpected just leaves the breakdown out.

    The transcript is read incrementally: state and file offset are cached per
    session in ~/.cache/claude/ctx/<session_id>.json.
    """

    def __init__(self, session_id, transcript):
        self.path = os.path.join(CACHE_DIR, "ctx", f"{session_id}.json")
        self.transcript = transcript
        self.s = {
            "version": STATE_VERSION,
            "offset": 0,
            "base_tokens": None,  # input tokens of the first response
            "first_chars": {"system": 0, "system_extra": 0, "tools": 0, "mcp": 0, "memory": 0, "messages": 0},
            "shape": None,  # latest {"system", "tools", "mcp"} chars
        }
        try:
            with open(self.path) as f:
                saved = json.load(f)
            if saved.get("version") == STATE_VERSION:  # else rebuilt from the transcript
                self.s.update(saved)
        except (OSError, ValueError):
            self._prune()

    def _prune(self):
        # new session: drop states of sessions untouched for a week
        d = os.path.dirname(self.path)
        try:
            for name in os.listdir(d):
                p = os.path.join(d, name)
                if time.time() - os.path.getmtime(p) > 7 * 86400:
                    os.remove(p)
        except OSError:
            pass

    def _save(self):
        try:
            os.makedirs(os.path.dirname(self.path), exist_ok=True)
            tmp = self.path + ".tmp"
            with open(tmp, "w") as f:
                json.dump(self.s, f)
            os.replace(tmp, self.path)
        except OSError:
            pass

    def _read_new_lines(self):
        try:
            with open(self.transcript, "rb") as f:
                if os.fstat(f.fileno()).st_size < self.s["offset"]:
                    self.s["offset"] = 0  # rewritten
                f.seek(self.s["offset"])
                data = f.read()
        except OSError:
            return []
        end = data.rfind(b"\n") + 1  # keep a partial last line for next time
        self.s["offset"] += end
        return data[:end].splitlines()

    def _parse(self, line):
        first = self.s["base_tokens"] is None
        if b'"api-request-shape"' in line:
            d = json.loads(line)
            shape = d["shape"]
            sizes = {"system": sum(len(b.get("text", "")) for b in shape.get("system", [])),
                     "tools": 0, "mcp": 0}
            for t in shape.get("tools", []):
                key = "mcp" if t.get("name", "").startswith("mcp__") else "tools"
                sizes[key] += len(json.dumps(t))
            self.s["shape"] = sizes
            if first:
                for k, v in sizes.items():
                    self.s["first_chars"][k] = v
        elif first and b'"api-request-blob"' in line:
            msg = json.loads(line).get("message") or {}
            for block in msg.get("content") or []:
                text = block.get("text") or ""
                if msg.get("role") == "system":
                    key = "system_extra"  # system prompt sent as a message (env, skills...)
                elif "Contents of " in text and ("CLAUDE.md" in text or "MEMORY.md" in text):
                    key = "memory"
                else:
                    key = "messages"
                self.s["first_chars"][key] += len(text)
        elif first and b'"usage"' in line and b'"assistant"' in line:
            d = json.loads(line)
            if d.get("type") == "assistant" and not d.get("isSidechain"):
                u = (d.get("message") or {}).get("usage") or {}
                total = sum(u.get(k) or 0 for k in
                            ("input_tokens", "cache_creation_input_tokens", "cache_read_input_tokens"))
                if total:
                    self.s["base_tokens"] = total

    def compute(self, used):
        """Tokens per category (dict), or None when it can't be estimated."""
        try:
            lines = self._read_new_lines()
            for line in lines:
                self._parse(line)
            if lines:
                self._save()
        except (ValueError, KeyError, TypeError, AttributeError):
            return None
        base, chars, shape = self.s["base_tokens"], self.s["first_chars"], self.s["shape"]
        if not base or not shape or not sum(chars.values()):
            return None
        ratio = base / sum(chars.values())  # tokens per char
        out = {k: shape[k] * ratio for k in ("system", "tools", "mcp")}
        out["system"] += chars["system_extra"] * ratio
        out["memory"] = chars["memory"] * ratio
        out["messages"] = max(0, used - sum(out.values()))
        return out


def git_branch(cwd):
    try:
        out = subprocess.run(
            ["git", "-C", cwd, "branch", "--show-current"],
            capture_output=True, text=True, timeout=0.5,
        )
        return out.stdout.strip()
    except (OSError, subprocess.SubprocessError):
        return ""


def cache_five_hour(win):
    pct, reset = round(win.get("used_percentage") or 0), int(win.get("resets_at") or 0)
    try:
        os.makedirs(CACHE_DIR, exist_ok=True)
        tmp = os.path.join(CACHE_DIR, "usage.tmp")
        with open(tmp, "w") as f:
            f.write(f"{pct} {reset}\n")
        os.replace(tmp, os.path.join(CACHE_DIR, "usage"))  # atomic for tmux
    except OSError:
        pass


def line_session(d):
    model = (d.get("model") or {}).get("display_name") or "Claude"
    left = f"{MAGENTA}{ICON['model']} {model}{RESET}"
    effort = (d.get("effort") or {}).get("level")
    if effort:
        left += f" {GREY}{ICON['effort']} {effort}{RESET}"
    if d.get("fast_mode"):
        left += f" {ORANGE}{ICON['fast']} fast{RESET}"

    cur = (d.get("context_window") or {}).get("current_usage")
    if cur:
        fresh = (cur.get("input_tokens") or 0) + (cur.get("cache_creation_input_tokens") or 0)
        # second-tier info: plain grey
        left += (f"{SEP}{GREY}({ICON['cached']} {tokens(cur.get('cache_read_input_tokens'))} "
                 f"{ICON['fresh']} {tokens(fresh)} "
                 f"{ICON['out']} {tokens(cur.get('output_tokens'))}){RESET}")
    cache = d.get("prompt_cache") or {}
    if cache.get("hit_ratio") is not None:
        hit = cache["hit_ratio"] * 100
        cold = "" if cache.get("warm", True) else " cold"
        left += f" {GREY}{ICON['hit']} {hit:.0f}%{cold}{RESET}"

    cwd = (d.get("workspace") or {}).get("current_dir") or d.get("cwd") or os.getcwd()
    right = f"{BLUE}{ICON['dir']} {os.path.basename(cwd.rstrip('/')) or '/'}{RESET}"
    branch = git_branch(cwd)
    if branch:
        right += f" {CYAN}{ICON['branch']} {branch}{RESET}"
    cost = d.get("cost") or {}
    added, removed = cost.get("total_lines_added") or 0, cost.get("total_lines_removed") or 0
    if added or removed:
        right += f"{SEP}{GREEN}+{added}{RESET} {RED}-{removed}{RESET}"
    return align(left, right)


def context_bar(parts, used, size):
    """Bar split by category colors (or one level color without a breakdown)."""
    if not parts:
        pct = used / size * 100
        filled = min(BAR_WIDTH, round(pct / 100 * BAR_WIDTH))
        return f"{level_color(pct)}{'▰' * filled}{GREY}{'▱' * (BAR_WIDTH - filled)}{RESET}"
    out, cum, cells = "", 0, 0
    for key, _, color in CATEGORIES:
        cum += parts[key]
        end = min(BAR_WIDTH, round(cum / size * BAR_WIDTH))
        out += color + "▰" * (end - cells)
        cells = end
    return f"{out}{GREY}{'▱' * (BAR_WIDTH - cells)}{RESET}"


def line_usage(d):
    ctx = d.get("context_window") or {}
    size = ctx.get("context_window_size") or 200_000
    used = ctx.get("total_input_tokens") or 0
    pct = ctx.get("used_percentage")
    pct = pct if pct is not None else used / size * 100

    parts = None
    if used and d.get("session_id") and d.get("transcript_path"):
        parts = ContextBreakdown(d["session_id"], d["transcript_path"]).compute(used)

    left = (f"{ICON['ctx']} {context_bar(parts, used, size)} {level_color(pct)}{pct:.0f}%{RESET} "
            f"{tokens(used)}{GREY}/{tokens(size)}{RESET}")
    if parts:
        legend = " ".join(f"{icon} {tokens(parts[key])}"
                          for key, icon, _ in CATEGORIES
                          if key != "mcp" or parts[key])
        left += f" {GREY}[{legend}]{RESET}"  # second-tier info: plain grey

    right = []
    limits = d.get("rate_limits") or {}
    now = time.time()
    for key, label in (("five_hour", "5h"), ("seven_day", "7d")):
        win = limits.get(key)
        if not win:
            continue
        if key == "five_hour":
            cache_five_hour(win)
        p = win.get("used_percentage") or 0
        seg = f"{level_color(p)}{ICON[label]} {label} {p:.0f}%{RESET}"
        if win.get("resets_at"):
            seg += f" {GREY}{ICON['reset']} {duration(win['resets_at'] - now)}{RESET}"
        right.append(seg)
    return align(left, SEP.join(right))


def main():
    raw = sys.stdin.read()
    try:
        d = json.loads(raw)
    except ValueError:
        d = {}
    try:
        out = line_session(d) + "\n" + line_usage(d)
    except Exception:  # never leave the statusline blank: show the error instead
        import traceback
        err = traceback.format_exc()
        out = f"{RED}statusline error:{RESET} {err.strip().splitlines()[-1]}"
        raw += "\n" + err
    print(out)
    # last run, to debug what Claude Code sends and gets back
    try:
        with open(os.path.join(CACHE_DIR, "statusline.last"), "w") as f:
            f.write(f"COLUMNS={os.environ.get('COLUMNS')}\n{raw}\n---\n{out}\n")
    except OSError:
        pass


if __name__ == "__main__":
    main()
