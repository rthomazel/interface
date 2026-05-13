## Architecture & Patterns

**Error Handling:** Don't panic. Return errors explicitly.
Wrap errors with context: `errs.Wrap(err, "doing something")`.
Use `errors.Is` and `errors.As` for checking.
mock\_\*.go files can be ignored entirely while working, if there are test errors, regenerate mocks.
new env vars should be read in main.go and added in k8s/{prod,qa}/\*.yaml
