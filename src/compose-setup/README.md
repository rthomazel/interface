# compose-setup

Centralized source for `bin/setup` scripts deployed across all projects.

Assembled by `bin/compose-setup`.

## How it works

`bin/compose-setup` assembles a `bin/setup` for each project by concatenating:

1. `header.sh` — shebang, strict mode, `SCRIPT_DIR`, `ENV_FILE`
2. One function file per entry in `FUNCS[project]`
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
bin/compose-setup

# Check specific projects
bin/compose-setup server comms

# Deploy all
bin/compose-setup --commit

# Deploy specific
bin/compose-setup --commit server comms
```

## Adding a function

1. Create `<name>.sh` in `src/compose-setup/` with one function definition and a single-line comment above it.
2. Add `<name>` to `FUNCS[project]` for each project that needs it in `bin/compose-setup`.
3. Run `bin/compose-setup` to verify, `--commit` to deploy.

Design rules for functions:

- **No external dependencies** — only bash builtins, standard Unix tools, and tools the function itself installs.
- **No hard failures** — optional steps must be guarded with `|| true` or `|| echo ... >&2`; let the caller's `set -e` catch only genuine unrecoverable errors.
- **Conditionals contained** — branch logic lives inside the function; the assembled footer is always a flat unconditional call list.

## Adding a project

1. Add an entry to `FUNCS` in `bin/compose-setup`.
2. Run `bin/compose-setup --commit <project>`.

## Function index

<!-- AGENTS: run the snippet below from src/compose-setup/, display output as Markdown -->

```bash
printf '| Function | Description |\n| --- | --- |\n'; for f in *.sh; do name=$(basename "$f" .sh); desc=$(grep -m1 '^#' "$f" | sed 's/^# *//'); printf '| `%s` | %s |\n' "$name" "$desc"; done
```
