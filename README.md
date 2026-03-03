# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/) on Arch Linux ([Omarchy](https://omarchy.com/)).

## Packages

| Package | Config |
|---------|--------|
| git | Git config + global ignore |
| starship | Shell prompt |
| claude | Claude Code settings, skills, persona, output-styles, MCP configs |
| gga | Gentleman Guardian Angel (AI code review) config + rules |
| hypr | Hyprland monitors config only |
| opencode | OpenCode (Cursor) config: SDD skills, commands, plugins, AGENTS.md |

## Why the dot-directories inside each package?

Stow creates symlinks in the **parent directory** relative to where you run it. Since we run `stow <package>` from `~/dotfiles/`, everything inside the package folder gets symlinked into `~/`.

```
~/dotfiles/claude/.claude/settings.json  →  ~/.claude/settings.json
~/dotfiles/gga/.config/gga/config        →  ~/.config/gga/config
```

The dot-prefixed subdirectory (`.claude/`, `.config/`) mirrors the real path in your home directory — stow needs that structure to know WHERE to place the symlink.

## Credits

- [gentleman-programming/gentle-ai](https://github.com/gentleman-programming/gentle-ai) —
  SDD workflow, skills framework, and base configurations

## Usage

```bash
# Clone
git clone git@github.com:felipe3dfx/dotfiles.git ~/dotfiles

# Stow all packages
cd ~/dotfiles
stow */

# Stow a single package
stow git
```
