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
