# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Personal dotfiles for Arch Linux (Omarchy) managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level directory is a stow package that mirrors the home directory structure (e.g., `nvim/.config/nvim/` symlinks to `~/.config/nvim/`).

## Commands

```bash
# Stow all packages (run from ~/dotfiles)
stow */

# Stow a single package
stow nvim

# Unstow (remove symlinks)
stow -D nvim

# Restow (useful after moving files around)
stow -R nvim
```

## Architecture

**17 stow packages**, each self-contained with its XDG-compliant path structure:

- **Terminals**: `alacritty`, `kitty`, `ghostty` — independent terminal emulator configs
- **Hyprland desktop**: `hypr` (window manager, split into per-concern `.conf` files), `waybar` (panel), `walker` (launcher)
- **Editor**: `nvim` — LazyVim-based Neovim setup; plugins in `nvim/.config/nvim/lua/plugins/`, config in `lua/config/`
- **CLI tools**: `tmux`, `lazygit`, `lazydocker`, `starship`, `mise`, `btop`, `fastfetch`
- **Git**: global config with SSH signing via 1Password, rebase-on-pull, rerere enabled
- **Claude Code**: `claude/.claude/` — settings, statusline script, and 9 SDD (Spec-Driven Development) skills

## Key Conventions

- Every config file lives under its package's `.config/` subtree (XDG base directory spec)
- Hyprland config is split by concern: `bindings.conf`, `monitors.conf`, `looknfeel.conf`, `input.conf`, etc. — not a single monolithic file
- Git commits are GPG-signed with SSH keys (`gpg.format = ssh`)
- Neovim uses LazyVim; add plugins by creating new files in `lua/plugins/`
