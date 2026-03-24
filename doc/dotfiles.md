# dotfiles/

Files here are symlinked into `$HOME`. The install mechanism is not in this repo
(managed manually or by a separate tool).

## Shell

| File                | Purpose                                                                                                                                                                                                                      |
| ------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `.bashrc`           | Main interactive shell config. Sets exports, sources libs and aliases.                                                                                                                                                       |
| `.bash_profile`     | Login shell — sources `.bashrc`.                                                                                                                                                                                             |
| `.bash_env`         | Non-interactive env loaded via `$BASH_ENV`. Sets `$GOPRIVATE`, `$T0_COLOR`, sources `lib.sh`, extends `$PATH`.                                                                                                               |
| `.bash_logout`      | Cleanup on logout.                                                                                                                                                                                                           |
| `.bashrc.linux.sh`  | Linux-specific bash config.                                                                                                                                                                                                  |
| `.bashrc.mac.sh`    | macOS-specific bash config.                                                                                                                                                                                                  |
| `.aliases.sh`       | Cross-platform aliases: navigation, work shortcuts (psql, gcloud), typo corrections, git aliases.                                                                                                                            |
| `.aliases.linux.sh` | Linux aliases: ls, mv, wl-copy/paste, pacman/yay wrappers, chromium VPN.                                                                                                                                                     |
| `.aliases.mac.sh`   | macOS aliases.                                                                                                                                                                                                               |
| `lib.sh`            | **Core library.** Logging functions: `log`, `debug`, `err`, `warn`, `fatal`, `msg`, `msgln`. Helpers: `macos`, `requested_help`, `is_me`, `term_emulator`. Color via `$T0_COLOR`. Kept in sync with `github.com/tcodes0/sh`. |
| `lib-git-prompt.sh` | Git prompt helpers, exports `$GIT_BRANCH`.                                                                                                                                                                                   |
| `lib-prompt.sh`     | PS1 prompt builder.                                                                                                                                                                                                          |

## Key exports (from `.bashrc`)

| Variable      | Value                                                       |
| ------------- | ----------------------------------------------------------- |
| `DOTFILES`    | `$HOME/Desktop/interface/dotfiles`                          |
| `BASH_ENV`    | `$HOME/.bash_env`                                           |
| `GOPRIVATE`   | `github.com/eleanorhealth/* github.com/tcodes0/*`           |
| `T0_COLOR`    | `true` (enables ANSI color in lib.sh logging)               |
| `EDITOR`      | `code -w`                                                   |
| `PUSH_REPOS`  | Space-separated list of repo names for `lazy-git` auto-push |
| `KNOWN_HOSTS` | Array of known machine hostnames                            |

## .config/

| Path                                | Purpose                                                                   |
| ----------------------------------- | ------------------------------------------------------------------------- |
| `Claude/claude_desktop_config.json` | Claude Desktop config. Registers `jailMPC` MCP server via Docker Compose. |
| `jj/config.toml`                    | Jujutsu global config.                                                    |
| `jj/repos`                          | Known jj repos list.                                                      |
| `code*/User/`                       | VSCode / VSCodium settings and keybindings.                               |
| `systemd/user/`                     | User systemd service units.                                               |
| `autostart/guake.desktop`           | Autostart Guake terminal on login.                                        |
| `keymap.xkb`                        | Custom XKB keyboard layout.                                               |
| `htop/htoprc`                       | htop config.                                                              |
| `ollama/`                           | Ollama model config files (`aux-chat`, `aux-code`).                       |
| `fontconfig/`                       | Font rendering config.                                                    |

## Other dotfiles

| File                       | Purpose                                     |
| -------------------------- | ------------------------------------------- |
| `.emacs`                   | Emacs config.                               |
| `.fonts/`                  | Custom fonts (DejaVu, 16bit, etc.).         |
| `.commitlintrc.yml`        | Commitlint rules for conventional commits.  |
| `.cspell.config.yml`       | cspell dictionary/config for spellchecking. |
| `.chatgpt-cli-config.yaml` | chatgpt-cli config.                         |
| `.fonts.conf`              | Fontconfig (legacy location).               |
