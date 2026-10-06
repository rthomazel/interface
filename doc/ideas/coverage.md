## Final coverage plan

Build a self-contained coverage system around **Go + GitHub Actions**, without Codecov/Coveralls.

### 1. Run coverage as part of the existing test job

Do not run tests a second time just to collect coverage.

Change the existing test invocation to:

```bash
go test ./... -coverprofile=coverage.out
```

This produces the coverage profile during the normal test execution.

Then use Go's built-in tooling to generate reports:

```bash
go tool cover -func=coverage.out > coverage.txt
go tool cover -html=coverage.out -o coverage.html
```

No additional test execution is required.

### 2. Generate a rich coverage artifact

Each coverage run should produce a directory along these lines:

```text
coverage/
├── coverage.out
├── coverage.txt
├── coverage.html
├── coverage.json
└── summary.json
```

The exact files can evolve, but the important pieces are:

- `coverage.out` — raw Go coverage profile
- `coverage.txt` — human-readable function/package coverage
- `coverage.html` — interactive Go coverage browser
- machine-readable JSON — useful for CI comparisons and future tooling
- summary metadata — commit, branch, overall coverage, changed-line coverage, etc.

Upload this directory with `actions/upload-artifact`.

The PR artifact gives developers a downloadable, interactive report without needing an external coverage service.

### 3. Persist `main` coverage using Actions artifacts

Every successful coverage run on `main` uploads a baseline artifact.

Conceptually:

```text
main
 │
 └── coverage workflow
       │
       ├── run tests + coverage
       ├── generate reports
       └── upload baseline artifact
```

The baseline should include enough information to reproduce the comparison, preferably the raw `coverage.out` plus machine-readable metadata rather than just the aggregate percentage.

For example:

```json
{
  "commit": "abc123...",
  "coverage": 73.42
}
```

The PR workflow retrieves the baseline corresponding to the PR's base commit/main state rather than simply trusting an arbitrary latest artifact. This avoids incorrect comparisons when `main` is changing concurrently.

### 4. Compare PR coverage against `main`

For every PR:

```text
main coverage: 73.42%
PR coverage:   74.18%
difference:    +0.76%
```

The primary coverage gate is:

```text
PR overall coverage >= main overall coverage
```

So an existing project can start at whatever coverage it currently has and improve organically. There is no arbitrary requirement to immediately reach 80% or 90%.

A regression:

```text
main: 73.42%
PR:   72.91%
```

fails the GitHub Actions check.

### 5. Add changed-line coverage

Overall coverage alone isn't sufficient because a PR could add a substantial amount of untested code while the global percentage barely moves.

Therefore add a second gate:

```text
Overall coverage >= main coverage
AND
Changed-line coverage >= configured threshold
```

For example:

```text
Overall coverage       73.42 → 74.18%    PASS
Changed-line coverage             91.3%  PASS
```

Changed-line coverage is calculated by:

1. Getting the PR's diff against its base commit.
2. Identifying added/modified source lines.
3. Correlating those lines with Go's `coverage.out`.
4. Calculating the percentage of changed executable statements covered by tests.

The threshold can be configurable, e.g. 80% or 90%.

This gives the system two complementary guarantees:

- Existing coverage does not regress.
- New/modified code is actually tested.

### 6. Put the result directly in the GitHub Actions summary

Use `$GITHUB_STEP_SUMMARY` to produce a useful report directly in the Actions UI.

Something like:

```text
## Coverage

| Metric | Main | PR | Change | Status |
|---|---:|---:|---:|---|
| Overall | 73.42% | 74.18% | +0.76% | PASS |
| Changed lines | — | 91.3% | — | PASS |

Coverage gate: PASS
```

For a failing PR:

```text
## Coverage

| Metric | Main | PR | Change | Status |
|---|---:|---:|---:|---|
| Overall | 73.42% | 72.91% | -0.51% | FAIL |
| Changed lines | — | 91.3% | — | PASS |

Coverage gate: FAIL
```

The detailed HTML report remains available from the artifact.

### 7. Resulting workflow

The overall system becomes:

```text
                         GitHub Actions
                              │
                    ┌─────────┴─────────┐
                    │                   │
                  main                  PR
                    │                   │
             go test ./...       go test ./...
             -coverprofile       -coverprofile
                    │                   │
             generate reports    generate reports
                    │                   │
                    ▼                   ▼
             upload artifact     retrieve main
                    │              baseline
                    │                   │
                    │            ┌──────┴──────┐
                    │            │             │
                    │         overall      changed-line
                    │         coverage       coverage
                    │            │             │
                    │            └──────┬──────┘
                    │                   │
                    │             coverage gate
                    │                   │
                    │             ┌─────┴─────┐
                    │             │           │
                    │           PASS        FAIL
                    │             │           │
                    └─────────────┴───────────┘
                                  │
                         GitHub Actions Summary
                                  +
                         downloadable HTML report
```

### 8. Why this approach

It gives you essentially the useful parts of a coverage service while keeping the infrastructure inside GitHub:

- No external service.
- No additional test run.
- Native Go coverage tooling.
- Persistent `main` baseline via Actions artifacts.
- Coverage regression detection.
- Changed-line coverage.
- Interactive HTML reports.
- Machine-readable coverage data for future tooling.
- PR/Actions visibility.
- Coverage becomes a normal required GitHub check through branch protection.

The core implementation should be relatively small. The potentially more substantial custom piece is the **changed-line coverage calculation**; everything else is mostly wiring Go's existing coverage tools into GitHub Actions.