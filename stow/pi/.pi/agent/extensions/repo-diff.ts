import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { matchesKey, sliceByColumn, truncateToWidth } from "@earendil-works/pi-tui";

const safeText = (text: string) => text.replace(/[\x00-\x1f\x7f-\x9f]/g, (char) =>
  char === "\t" ? "    " : `\\x${char.charCodeAt(0).toString(16).padStart(2, "0")}`);

export default function (pi: ExtensionAPI) {
  pi.registerCommand("diff", {
    description: "Browse staged, unstaged, and untracked Git changes",
    handler: async (_args, ctx) => {
      if (ctx.mode !== "tui") {
        ctx.ui.notify("/diff requires interactive mode.", "warning");
        return;
      }
      const git = (cwd: string, args: string[]) => pi.exec("git", ["--no-optional-locks", "--literal-pathspecs", ...args], {
        cwd, timeout: 5000, maxBuffer: 512 * 1024,
      });
      const root = await git(ctx.cwd, ["rev-parse", "--show-toplevel"]);
      if (root.code !== 0 || root.killed) {
        ctx.ui.notify("Could not find the Git working tree.", "warning");
        return;
      }
      const cwd = root.stdout.replace(/\r?\n$/, "");
      const status = await git(cwd, ["status", "--porcelain=v1", "-z", "--no-renames", "--untracked-files=all"]);
      if (status.code !== 0 || status.killed || status.truncated) {
        ctx.ui.notify("Could not read Git status (failed, timed out, or exceeded 512 KiB).", "warning");
        return;
      }

      const files = new Map<string, { path: string; kind: string }>();
      for (const entry of status.stdout.split("\0")) {
        if (entry.length < 4) continue;
        const path = entry.slice(3);
        const add = (kind: string) => files.set(`${kind}  ${safeText(JSON.stringify(path))}`, { path, kind });
        if (entry.startsWith("??")) add("Untracked");
        else {
          if (entry[0] !== " ") add("Staged");
          if (entry[1] !== " ") add("Unstaged");
        }
      }
      if (!files.size) {
        ctx.ui.notify("Working tree is clean.", "info");
        return;
      }

      while (true) {
        const label = await ctx.ui.select("Repository diff", [...files.keys()]);
        if (!label) return;
        const file = files.get(label);
        if (!file) return;
        const untracked = file.kind === "Untracked";
        const result = await git(cwd, [
          "diff", "--no-color", "--no-ext-diff", "--no-textconv", "--no-renames",
          ...(untracked ? ["--no-index", "--", "/dev/null", `./${file.path}`]
            : [...(file.kind === "Staged" ? ["--cached"] : []), "--", file.path]),
        ]);
        if (result.truncated || result.killed || (result.code !== 0 && !(untracked && result.code === 1))) {
          ctx.ui.notify("Could not read this diff (failed, timed out, or exceeded 512 KiB).", "warning");
          continue;
        }
        const lines = (result.stdout.replace(/\n$/, "") || "No patch available.").split("\n").map(safeText);
        const back = await ctx.ui.custom<boolean>((tui, theme, keys, done) => {
          let row = 0;
          let col = 0;
          const height = () => Math.max(1, Math.min(32, tui.terminal.rows - 6));
          return {
            capturesViewportInput: true,
            invalidate() {},
            render(width) {
              row = Math.min(row, Math.max(0, lines.length - height()));
              const body = lines.slice(row, row + height()).map((line) => {
                const color = line.startsWith("@@") ? "accent"
                  : line.startsWith("+") ? "toolDiffAdded"
                  : line.startsWith("-") ? "toolDiffRemoved" : "toolDiffContext";
                return theme.fg(color, sliceByColumn(line, col, width, true));
              });
              return [
                truncateToWidth(theme.fg("accent", label), width),
                ...body,
                truncateToWidth(theme.fg("dim", `${row + 1}–${Math.min(row + height(), lines.length)}/${lines.length} · ↑↓ PgUp/PgDn scroll · ←→ pan · Esc files · q close`), width),
              ];
            },
            handleInput(input) {
              if (keys.matches(input, "tui.select.cancel")) return done(true);
              if (matchesKey(input, "q") || matchesKey(input, "ctrl+c")) return done(false);
              if (matchesKey(input, "up")) row--;
              else if (matchesKey(input, "down")) row++;
              else if (matchesKey(input, "pageUp")) row -= height();
              else if (matchesKey(input, "pageDown")) row += height();
              else if (matchesKey(input, "home")) { row = 0; col = 0; }
              else if (matchesKey(input, "end")) row = lines.length;
              else if (matchesKey(input, "left")) col = Math.max(0, col - 8);
              else if (matchesKey(input, "right")) col += 8;
              else return;
              row = Math.max(0, Math.min(row, Math.max(0, lines.length - height())));
              tui.requestRender();
            },
          };
        });
        if (!back) return;
      }
    },
  });
}
