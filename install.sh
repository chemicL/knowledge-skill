#!/usr/bin/env bash
# knowledge-skill · https://github.com/chemicL/knowledge-skill · MIT © 2026 Dariusz Jędrzejczyk
# Install the /knowledge skill into ~/.claude/skills/knowledge.
# Personal preferences live in ~/.claude/knowledge/my-sources.md and are never overwritten.
set -euo pipefail

src="$(cd "$(dirname "$0")" && pwd)"
target="$HOME/.claude/skills/knowledge"
personal_dir="$HOME/.claude/knowledge"

mkdir -p "$target"
rsync -a --delete "$src/skill/" "$target/"
echo "Installed skill -> $target"

mkdir -p "$personal_dir"
if [ ! -f "$personal_dir/my-sources.md" ]; then
  cp "$src/templates/my-sources.md" "$personal_dir/my-sources.md"
  echo "Created personal sources file -> $personal_dir/my-sources.md"
else
  echo "Kept existing personal sources -> $personal_dir/my-sources.md"
fi
