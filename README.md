# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/) on Arch Linux ([Omarchy](https://omarchy.com/)).

## Packages

| Package | Config |
|---------|--------|
| nvim | Neovim (LazyVim) |
| tmux | Terminal multiplexer |
| git | Git config + global ignore |
| starship | Shell prompt |
| claude | Claude Code settings, skills, persona, output-styles, MCP configs |
| gga | Gentleman Guardian Angel (AI code review) config + rules |
| hypr | Hyprland monitors config only |

## Usage

```bash
# Clone
git clone git@github.com:felipe3dfx/dotfiles.git ~/dotfiles

# Stow all packages
cd ~/dotfiles
stow */

# Stow a single package
stow nvim
```
