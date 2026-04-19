check your jail mcp tools for a context tool, and call it on the project I'll provide.
exec sync is the tool for most tasks, it's a shell: cat, find, grep, sed.
for security, this is the only way to interact with project files.
if the project's programming language isn't installed, call the setup tool on the project path.
exec background is for slow commands, and multitasking.
fyi: projects name like foo, foo-1, are just worktrees of foo.
start here:
1) read AGENTS.md at the root first, search for project docs in .md files, normally under doc/.
2) if necessary: start the setup tool and while it runs in background, go do some other work.
Go projects might have private dependencies that won't install unless setup tool is ran (bin/setup normally)

project:
task:

