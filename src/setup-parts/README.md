# setup-parts

Centralized source for `bin/setup` scripts deployed across all projects.

## How it works

`bin/install-setup` assembles a `bin/setup` for each project by concatenating:

1. `header.sh` — shebang, strict mode, `SCRIPT_DIR`, `ENV_FILE`
2. One function file per entry in `FUNCS[project]` from `fn/`
3. A footer: each function name on its own line, then `echo "setup complete"`

Each function file contains exactly one shell function definition.
Branch logic lives inside the function — the footer is a flat unconditional call list.

## Environments

Assembled `bin/setup` scripts run in three environments:

| Environment           | `GITHUB_TOKEN`                       | Notes                                                                          |
| --------------------- | ------------------------------------ | ------------------------------------------------------------------------------ |
| Local dev machine     | Not set                              | SSH configured for private repos; token-dependent steps are skipped gracefully |
| Cloud agent container | Injected (`CLAUDE_CODE_REMOTE=true`) | Token available at runtime without `.env`                                      |
| Jail agent container  | Sourced from `.env`                  | Functions that need the token source `$ENV_FILE` themselves                    |

All assembled scripts are idempotent — safe to re-run at any time.

## Usage

```sh
# Check all projects for drift (default, no writes)
bin/install-setup

# Check specific projects
bin/install-setup server comms

# Deploy all
bin/install-setup --commit

# Deploy specific
bin/install-setup --commit server comms
```

## Adding a function

1. Create `fn/<name>.sh` with one function definition and a single-line comment above it.
2. Add `<name>` to `FUNCS[project]` for each project that needs it in `bin/install-setup`.
3. Run `bin/install-setup` to verify, `--commit` to deploy.

Design rules for functions:

- **No external dependencies** — only bash builtins, standard Unix tools, and tools the function itself installs.
- **No hard failures** — optional steps must be guarded with `|| true` or `|| echo ... >&2`; let the caller's `set -e` catch only genuine unrecoverable errors.
- **Conditionals contained** — branch logic lives inside the function; the assembled footer is always a flat unconditional call list.

## Adding a project

1. Add an entry to `FUNCS` in `bin/install-setup`.
2. Run `bin/install-setup --commit <project>`.

## Function index

<!-- AGENTS: run the snippet below from src/setup-parts/, display output as Markdown -->

```bash
printf '| Function | Description |\n| --- | --- |\n'; for f in fn/*.sh; do name=$(basename "$f" .sh); desc=$(grep -m1 '^#' "$f" | sed 's/^# *//'); printf '| `%s` | %s |\n' "$name" "$desc"; done
```
