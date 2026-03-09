#!/bin/bash
# Sync skills from canonical source to claude and opencode stow packages
# Run this after modifying any skill in skills/

set -e

cd "$(dirname "$0")"

rm -rf claude/.claude/skills/ opencode/.config/opencode/skills/
cp -r skills/ claude/.claude/skills/
cp -r skills/ opencode/.config/opencode/skills/

echo "Skills synced to claude and opencode"
