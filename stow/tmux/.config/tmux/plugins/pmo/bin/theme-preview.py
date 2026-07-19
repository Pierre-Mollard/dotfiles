#!/usr/bin/env python3

import re
import sys
from pathlib import Path

theme = sys.argv[1]
path = Path.home() / ".config/tmux/plugins/pmo/themes" / f"{theme}_tmux.conf"

print(f"Theme: {theme}\n")

if not path.exists():
    print("Theme file not found.")
    raise SystemExit(0)

rx = re.compile(r'set -gq (@thm_[^ ]+) "(#[0-9A-Fa-f]{6})"')

for line in path.read_text().splitlines():
    m = rx.search(line)
    if not m:
        continue
    name, hexv = m.groups()
    r = int(hexv[1:3], 16)
    g = int(hexv[3:5], 16)
    b = int(hexv[5:7], 16)
    print(f"{name:<22} {hexv}  \x1b[48;2;{r};{g};{b}m    \x1b[0m")
