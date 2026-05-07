Call the jail MCP context tool at the start of each session to orient yourself.
Then run the setup tool on the project path to prepare the environment.
Use exec_sync for most file tasks (cat, find, grep, sed). This is the only way to interact with project files.
Use exec_background for slow commands; poll with the status tool. You can do other work while waiting.
  - Go projects may have private dependencies — run bin/setup, not just go mod download.
Start by reading AGENTS.md at the project root, then look for docs in .md files under doc/.
Projects named foo-1, foo-2 are git worktrees of foo — same codebase, different branch.

Editing files in /projects/ via jail:
- str_replace cannot reach volume-mounted paths. Use Python via exec_sync instead.
- Always use a quoted heredoc (<< 'PYEOF') to prevent bash from interpreting backticks, $variables, or special characters inside the Python code.
- Prefer two small targeted replaces over one large multi-line block match — large blocks are brittle.

python3 << 'PYEOF'
with open('/projects/server/path/to/file', 'r') as f:
    content = f.read()
content = content.replace('old', 'new')
with open('/projects/server/path/to/file', 'w') as f:
    f.write(content)
print('ok')
PYEOF

project:
task: