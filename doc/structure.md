# Project Structure

`interface` is a personal dotfiles and scripts repo for Arch Linux (primary) and macOS (secondary).
The repo is managed with **jujutsu** (`jj`). Do not make commits manually.

## Directory Layout

```
interface/
├── bin/          # Executables added to $PATH ($HOME/bin symlinks here)
│   └── git/      # Git hooks
├── boot/         # EFI/bootloader configs (CLOVER)
├── doc/          # Project documentation (this folder)
├── dotfiles/     # Config files symlinked into $HOME
│   ├── .config/  # XDG config (jj, Claude, VSCode, etc.)
│   └── lib*.sh   # Shell libraries sourced at startup
├── etc/          # System configs symlinked into /etc
├── priv/         # Private/sensitive configs (not detailed here)
└── src/          # Go source for compiled tools
    ├── forex/
    └── presentvalue/
```

## Absolute-path symlinks

Some symlinks reference `/home/vacation/` or `/Users/thom.ribeiro/`. They only work in the
original environment. When cloning elsewhere, update the prefix to your home directory.

## How dotfiles are loaded

1. `.bashrc` sets `$DOTFILES=$HOME/Desktop/interface/dotfiles` and sources:
   - `lib.sh` — shell function library (logging, OS detection, etc.)
   - `lib-git-prompt.sh` — git PS1 helpers, exports `$GIT_BRANCH`
   - `lib-prompt.sh` — prompt construction
   - `.aliases.sh` — cross-platform aliases
   - `.aliases.linux.sh` or `.aliases.mac.sh` — OS-specific aliases
2. `.bash_env` sets `$BASH_ENV` so non-interactive scripts pick up `lib.sh` functions.
   Scripts check `$BASH_ENV` is set and fail early if not.
