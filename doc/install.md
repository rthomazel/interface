# install — Dotfiles Install Program

A `go run`-able install program at `src/install/`. Replaces t0filer for the `interface` repo.
Processes `install.rc` and applies file operations to the system.

## Usage

```bash
go run ./src/install                        # dry run (default, no changes)
go run ./src/install -c                     # commit changes
sudo go run ./src/install -c               # commit changes as root
go run ./src/install -config path/to/rc    # use a specific config file (default: install.rc)
go run ./src/install -v                    # print version
```

## Config file — `install.rc`

A single `install.rc` at the repo root covers all users and systems. The program tracks a
current `user` and `system` context as it reads the file, executing only the actions that
match the current runtime user and detected OS. Both can change freely mid-file.

Blank lines are ignored. Lines starting with `#` are comments and are ignored.

### Context declarations

| Declaration    | Effect                                                        |
| -------------- | ------------------------------------------------------------- |
| `user <n>`     | Set current user context; actions below run only as this user |
| `system linux` | Set current system context to Linux                           |
| `system mac`   | Set current system context to macOS (future)                  |

- If no `user` line appears before an action, a warning is printed and the action runs under the current user.
- If no `system` line appears, context defaults to `linux`.
- At the end of a run, if any actions were skipped due to a different user, a warning is printed listing the skipped users. Skipped-system actions are silent.

### Actions

| Action    | Args                       | Description                                              |
| --------- | -------------------------- | -------------------------------------------------------- |
| `check`   | `binary install-cmd`/line  | Verify binary exists; collect all failures, abort at end |
| `assert`  | command and hint in pairs  | Run a shell command; collect all failures, abort at end  |
| `message` | free text, multi-line      | Print a block of text to the user                        |
| `mkdir`   | one path/line              | Create directory and parents if it does not exist        |
| `link`    | path pairs                 | Create symlink; source first, link target second         |
| `copy`    | path pairs                 | Copy file; skipped if target exists and checksums match  |
| `enable`  | one unit/line              | `systemctl enable --now <unit>`                          |
| `chmod`   | `mode path`/line           | Apply permission mode to path                            |
| `reload`  | none                       | `systemctl daemon-reload`                                |

`$HOME` in paths is expanded to the current user home directory.
`enable`, `chmod`, and `reload` are Linux-only and implicitly skipped on other systems.

### `check` format

First token is the binary name, rest of line is the install command printed if missing.
All lines run before failing so every missing binary is surfaced at once.

```
check

git           pacman -S git
bash          pacman -S bash
docker        see https://docs.docker.com/get-docker/
mise          see https://mise.jdx.dev/getting-started.html
shfmt         go install mvdan.cc/sh/v3/cmd/shfmt@latest
golangci-lint see https://golangci-lint.run/welcome/install
```

Output on failure:
```
check: missing binaries
  git           pacman -S git
  mise          see https://mise.jdx.dev/getting-started.html
```

### `assert` format

Lines come in pairs: command line followed by hint line. An odd number of lines is a
parse error. Each command is run as a shell expression; non-zero exit = failure.
All assertions run before failing so every failure is surfaced at once.

```
assert

test "$SHELL" = /bin/bash
shell is not bash, run: chsh -s /bin/bash

docker stats --no-stream
docker daemon is not running, please start docker

mise --version
mise not found, see https://mise.jdx.dev/getting-started.html
```

### Execution order and failure

Actions execute in file order. `check` and `assert` each collect all failures within their
block then abort. Every other action fails immediately on error.

### Format example

```
user vacation
system linux

check

git           pacman -S git
bash          pacman -S bash
docker        see https://docs.docker.com/get-docker/
mise          see https://mise.jdx.dev/getting-started.html

assert

test "$SHELL" = /bin/bash
shell is not bash, run: chsh -s /bin/bash

docker stats --no-stream
docker daemon not running, please start docker

message

After installing mise, run:
  mise install

mkdir

/home/vacation/.config/somedir

link

/home/vacation/Desktop/interface/dotfiles/.bashrc
/home/vacation/.bashrc

/home/vacation/Desktop/interface/bin
/home/vacation/bin

user root
system linux

link

/home/vacation/Desktop/interface/etc/systemd/system/system-snapshot.timer
/etc/systemd/system/system-snapshot.timer

copy

/home/vacation/Desktop/interface/etc/fstab
/etc/fstab

enable

system-snapshot.timer
btrfs-scrub@Archlinux.timer

chmod

o+x /home/vacation

reload

system mac

# mac-specific equivalents here in the future
```

## Behavior

### No-op by default

Dry run unless `-c` or `-commit` is passed. Dry run prints what would change, nothing else.
`check` and `assert` always run even in dry run since they are read-only.

### Validate-first

Before applying any changes, all operations are validated. Validation runs the same checks
in both dry run and commit modes. If validation finds errors, the program exits before
touching anything. This surfaces all problems upfront rather than failing halfway through.

Validation checks:
- Source file exists
- Target parent directory exists (or will be created via `mkdir`)
- For `link`: if target exists, verify it already points to the correct source
- For `copy`: if target exists, checksum both files; identical = already done
- For `assert`: line count is even

### Idempotent

Re-running is safe. Each operation detects its already-complete state and skips:
- `link`: target is already a symlink to the correct source → skip
- `copy`: target exists and checksums match → skip
- `mkdir`: directory already exists → skip

`enable`, `chmod`, and `reload` always execute unconditionally.

### Broken link cleanup

Before linking, any broken symlink at the target path is removed. A warning is printed.

### Directory creation

If a target parent directory does not exist, it is created. A warning is printed.
`mkdir` in the config file creates directories explicitly with no warning.

### Fail fast at runtime

If an unexpected error occurs during commit (after validation passed), the program exits
immediately. The next run skips already-completed operations and picks up where it left off.

## File layout

```
src/install/
├── go.mod       # standalone module, no external dependencies
├── main.go      # flags, load config, filter by current user/system, validate, commit
├── config.go    # parse install.rc into a flat list of user+system-scoped operations
├── link.go      # link, copy, mkdir operations
├── check.go     # check, assert, message operations
└── system.go    # enable, reload, chmod operations
```

## todo once completed and tested

delete t0filer, migrate config files