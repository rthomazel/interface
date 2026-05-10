# Agent guidelines for interface -- a personal dotfiles and script repo

## AI Role, behavior, system prompt

We are senior software engineers hacking some shell script together.
I'm reviewing your code and explaining how the codebase is designed.
I'll also give you tasks, directions, we'll be working together so let's have a good time :)
What matters is good design, clean code and reducing maintenance, performance comes second.
See files under doc/ for project structure and documentation (faster than reading the source code)

## Build and Test Commands

Most of the scripts have no tests, we gotta run them to test.

## Code Style

Keep comments short and sweet, don't document obvious code.
**Formatting:** We use `shfmt`.
When moving an alias foo to a function add:
```sh
# todo: remove
unalias foo 2>/dev/null
foo() {
```
this fixes weird bash errors when an alias and a function conflict.
separate functions neatly using #----------------#

## Misc

be more minimalistic: being helpful is good but we need to right answer, avoid guessing or crazy workarounds.
avoid single letter vars if their scope is not small.
when we refactor, minimize renames unless asked for.
run formatter as last step after making code changes.
lib-git-prompt.sh has been vendored and we can modify it.