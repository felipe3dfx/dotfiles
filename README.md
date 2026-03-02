# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/) on Arch Linux ([Omarchy](https://omarchy.com/)).

## Packages

| Package | Config |
|---------|--------|
| alacritty | Terminal emulator |
| kitty | Terminal emulator |
| ghostty | Terminal emulator |
| nvim | Neovim (LazyVim) |
| tmux | Terminal multiplexer |
| git | Git config + global ignore |
| mise | Runtime version manager |
| starship | Shell prompt |
| claude | Claude Code settings, skills, persona, output-styles, MCP configs |
| gga | Gentleman Guardian Angel (AI code review) config + rules |
| hypr | Hyprland window manager (user overrides) |
| waybar | Waybar panel |
| walker | Walker launcher |
| btop | System monitor |
| fastfetch | System info fetch |

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
