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
| lazygit | Git TUI |
| lazydocker | Docker TUI |
| git | Git config + global ignore |
| mise | Runtime version manager |
| starship | Shell prompt |
| claude | Claude Code settings |

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
