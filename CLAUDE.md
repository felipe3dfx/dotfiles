# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Personal dotfiles for Arch Linux (Omarchy) managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level directory is a stow package that mirrors the home directory structure (e.g., `nvim/.config/nvim/` symlinks to `~/.config/nvim/`).

## Commands

```bash
# Stow all packages (run from ~/dotfiles)
stow */

# Stow a single package
stow git

# Unstow (remove symlinks)
stow -D claude

# Restow (useful after moving files around)
stow -R claude

# Sync skills to claude and opencode packages, then restow
./sync-skills.sh
```

## Architecture

**6 stow packages**, each self-contained with its XDG-compliant path structure:

- **Hyprland**: `hypr` — monitors config only (rest lives unmanaged in `~/.config/hypr/`)
- **CLI tools**: `starship`
- **Git**: global config with SSH signing via 1Password, rebase-on-pull, rerere enabled
- **Claude Code**: `claude/.claude/` — settings, statusline script, CLAUDE.md (persona + SDD orchestrator + engram protocol), output-styles, MCP configs
- **GGA**: `gga/.config/gga/` — Gentleman Guardian Angel AI code review config and AGENTS.md rules
- **OpenCode**: `opencode/.config/opencode/` — OpenCode config: commands, plugins, AGENTS.md

**Shared directory** (not a stow package):

- **`skills/`** — 24 AI agent skills (9 SDD v2.0, 10 framework/tool skills, skill-creator, branch-pr, issue-creation, skill-registry, _shared conventions). Canonical source, synced to `claude/.claude/skills/` and `opencode/.config/opencode/skills/` via `sync-skills.sh`. The copies are gitignored.
- **`docs/`** — SDD reference documentation (architecture, concepts, persistence, token economics, etc.). Not a stow package — reference material for AI agents.

## Key Conventions

- Every config file lives under its package's `.config/` subtree (XDG base directory spec)
- Hyprland monitors config is the only hypr file managed by stow; rest lives directly in `~/.config/hypr/`
- Git commits are GPG-signed with SSH keys (`gpg.format = ssh`)
- Skills are maintained in `skills/` (top-level) and copied to stow packages by `sync-skills.sh` — never edit skills inside `claude/` or `opencode/` directly
