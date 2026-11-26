# Bench MCP toolset

Shell and file editing is provided by the `bench` toolset.
Use `shell` for most file tasks (cat, find, grep).
Use `shell_background` for slow commands; poll with the status tool, you can do other work while waiting.

> note: You may see a `maintenance` toolset; this is another bench but on the host's environment.

## Using Shell:

- The canonical input field name is "commands", but "command" is also supported.
  - Good: `commands: ["echo 123"]`
  - Good: `command: ["echo 123"]`
- Provide inputs as a JSON array, not a string:
  - Good: `commands: ["echo 123"]`
  - Bad: `commands: "echo 123"`
- The whole input has to be parsable as JSON, be careful with character scaping.
  - Good: commands: ["cat some file | grep 'db\\|DB\\|sqlite'"]
  - Bad: commands: ["cat some file | grep 'db\|DB\|sqlite'"]
- Avoid complex here documents that will need a lot of scaping, those are error prone.

## Editing files:

- Use `file_replace` for targeted edits — finds a unique substring and replaces it. Returns a unified diff.
- Use `file_create` for big edits or creating a file. Returns a unified diff.
- Use `file_replace_all` to replace every occurrence of a substring (e.g. renaming a symbol). Also returns a unified diff.
- Prefer two small targeted replacements over one large multi-line block match — large blocks are brittle.
- Both tools error if the file doesn't exist or (for `file_replace`) if the substring isn't uniquely matched, which prevents silent corruption.

## Project setup

The setup tool offers a standard way to setup some repositories, bench can handle some of the work automatically.
Go projects may have private dependencies, go mod download without setup may fail — the setup tool runs bin/setup to set GOPRIVATE.
Before starting work, run the setup tool on the project path to prepare the environment, report errors.
