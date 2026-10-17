#!/usr/bin/env bash
# knowledge-skill · https://github.com/chemicL/knowledge-skill · MIT © 2026 Dariusz Jędrzejczyk
# Build dist/knowledge.zip for upload to the Claude desktop/web app (Customize > Skills).
# claude.ai accepts fewer frontmatter keys than Claude Code and has no $ARGUMENTS,
# so the packaged SKILL.md drops `argument-hint` and refers to the user's message instead.
set -euo pipefail

src="$(cd "$(dirname "$0")" && pwd)"
build="$src/dist/build/knowledge"

rm -rf "$src/dist"
mkdir -p "$build"
cp "$src/skill/"*.md "$build/"

python3 - "$build/SKILL.md" <<'PY'
import sys
p = sys.argv[1]
s = open(p, encoding="utf-8").read()
s = "\n".join(l for l in s.split("\n") if not l.startswith("argument-hint:"))
s = s.replace("The user asked: **$ARGUMENTS**",
              "The user's question is their message that triggered this skill. Flags in it: `--level beginner|intermediate|expert` sets the level, and `--kids` switches to kids-only mode.")
open(p, "w", encoding="utf-8").write(s)
PY

(cd "$src/dist/build" && zip -qr "$src/dist/knowledge.zip" knowledge)
rm -rf "$src/dist/build"
echo "Built $src/dist/knowledge.zip"
