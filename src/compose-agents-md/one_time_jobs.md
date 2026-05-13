## One-time jobs

All one-time jobs must be Argo Workflows. Each job lives under `cmd/<jobname>/main.go`. Never create Kubernetes Jobs or CronJobs for one-time work.

When adding a new one-time job, always include: a `k8s/prod/` and `k8s/qa/` Argo WorkflowTemplate YAML, a `RUN go build` line and a `COPY --from=builder` line in the Dockerfile, and a row in `doc/features/one-time-jobs.md`. Use `formdefpdfmigration` as the reference pattern.
