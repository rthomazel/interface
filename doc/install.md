# install — Dotfiles Install Program

A `go run`-able install program at `src/install/`.
Replaces t0filer for the `interface` repo.
Processes `install.rc` and applies file operations to the system.

## Usage

```bash
go run ./src/install -commit              # commit changes
go run ./src/install                      # dry run (default, no changes)
sudo go run ./src/install -commit         # commit changes as root
go run ./src/install -config path/to/rc   # use a specific config file (default: install.rc)
go run ./src/install -v                   # print version
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

| Action    | Args                      | Description                                              |
| --------- | ------------------------- | -------------------------------------------------------- |
| `check`   | `binary install-cmd`/line | Verify binary exists; collect all failures, abort at end |
| `assert`  | command and hint in pairs | Run a shell command; collect all failures, abort at end  |
| `message` | free text, multi-line     | Print a block of text to the user                        |
| `mkdir`   | one path/line             | Create directory and parents if it does not exist        |
| `link`    | path pairs                | Create symlink; source first, link target second         |
| `copy`    | path pairs                | Copy file; skipped if target exists and checksums match  |
| `enable`  | one unit/line             | `systemctl enable --now <unit>`                          |
| `chmod`   | `mode path`/line          | Apply permission mode to path                            |
| `reload`  | none                      | `systemctl daemon-reload`                                |

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
- For `link`: if target exists, verify it is a link and already points to the correct source
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
If a regular file occupies the path of the link, error
if a link exists, it must point to the correct target, if not remove and re-create.

### Directory creation

If a target parent directory does not exist, it is created. A warning is printed.
`mkdir` in the config file creates directories explicitly with no warning.

### Fail fast at runtime

If an unexpected error occurs during commit (after validation passed), the program exits
immediately. The next run skips already-completed operations and picks up where it left off.

### etc/

Because of complex boot time filesystem mounting order, and the current layout of /home/vacation as a sub volume, etc/ files should be copied not linked, by user root.

### git hooks

Hooks for commit and pull should re-run install to verify targets of copy and link are still accurate with new source files.

## Testing

### Test config — `src/install/test.rc`

A dedicated `test.rc` exercises every action and edge case. It is designed to run safely
in a temp directory without touching real system paths. Use it after any change to the
install program.

```bash
mkdir -p /tmp/install-test
go run ./src/install -config src/install/test.rc -c
```

The test config covers:

```
# no user declared — should warn and run as current user
system linux

# check: one present binary, one missing
check

bash         pacman -S bash
this-binary-does-not-exist pacman -S this-binary-does-not-exist

# assert: one passing, one failing
assert

test -d /tmp
/tmp should always exist

test -d /tmp/this-does-not-exist
hint for a failing assert

# message: should always print
message

This is a test message.
It spans multiple lines.

# mkdir: new dir and already-existing dir (idempotent)
mkdir

/tmp/install-test/newdir
/tmp/install-test/newdir

# link: new link, already-correct link (skip), broken link (cleanup + relink)
link

/tmp/install-test/newdir
/tmp/install-test/link-to-newdir

/tmp/install-test/newdir
/tmp/install-test/link-to-newdir

# copy: new copy, already-identical copy (skip), mismatched copy (error)
copy

/etc/hostname
/tmp/install-test/hostname-copy

/etc/hostname
/tmp/install-test/hostname-copy

# user block that will be skipped (prints end-of-run warning)
user nonexistent-user

link

/etc/hostname
/tmp/install-test/should-not-exist

# system block that will be skipped silently
system mac

message

This should not print on Linux.
```

Expected outcomes to verify manually:

- Warning printed for missing user declaration at top
- `check` fails listing the missing binary with its hint, does not abort before checking all
- `assert` fails listing the failing assertion with its hint, does not abort before checking all
- `message` always prints
- `mkdir` creates the new dir; second call skips silently
- `link` creates the link; second call skips (already correct); broken link triggers warning then relink
- `copy` copies the file; second call skips (checksums match); mismatched copy errors
- End-of-run warning lists `nonexistent-user` block was skipped
- Mac `message` block does not print

### Unit tests

The parts most prone to bugs and regressions are:

**`config.go` — parser.** The parser handles the most complex logic: context switching
(user/system mid-file), blank line and comment stripping, pair validation for link/copy,
even-line validation for assert, and the interaction between inherited vs explicit system
context. A bug here silently misroutes operations to the wrong user or system. Unit test
cases should cover: no user declared, user mid-file change, system mid-file change,
comments and blank lines interleaved, malformed pairs (odd count), malformed assert
(odd count), unknown action keyword.

**`link.go` — link and copy.** Idempotency logic is easy to get wrong. Unit test cases:
new link, already-correct link (skip), broken link (cleanup + relink), link pointing
elsewhere (error), new copy, identical copy (skip, checksum match), differing copy (error),
missing source (error), missing target parent (mkdir then proceed).

**`check.go` — check and assert.** Failure collection must not short-circuit. Test that
all lines are evaluated even when early lines fail. Assert even-line validation. Test
that assert runs shell expressions correctly and captures non-zero exit.

Tests live alongside source files in `src/install/` using the standard `_test.go` convention.
Where filesystem access is needed, use `t.TempDir()` to keep tests hermetic.

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
