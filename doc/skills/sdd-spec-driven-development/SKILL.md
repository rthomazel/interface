---
name: sdd-spec-driven-development
description: Use when the operator requests a specification or asks to plan and implement non-trivial software work using spec-driven development.
---

# SDD: Spec-Driven Development

Spec-driven development (SDD) is an engineering practice in which specifications
describe engineering intent and guide implementation by both agents and people.
The work is recorded in Markdown, written in English, structured with OKF
frontmatter, and kept in Git alongside the code.

- **Markdown** is the representation.
- **English** is the human- and agent-readable content.
- **OKF** provides lightweight structure and metadata.
- **Git** provides persistence, history, review, and collaboration.
- **`spc/`** is the location for specifications and related SDD artifacts.

A specification describes intended behavior and engineering intent. It is not a
report reconstructed from an existing implementation. Humans and agents may
write, refine, and maintain specifications; the operator resolves unresolved
questions of intent and scope.

## Workflow

Move through these steps in order:

```text
Read AGENTS.md
1 Specify
2 Plan
3 Task
4 Code
5 Ship
```

### 1. Read `AGENTS.md`

For SDD purposes, the project constitution is the repository's `AGENTS.md`.
It contains the high-level guidelines, constraints, conventions, and
expectations that govern work across the project.

Read it before doing SDD work.

If `AGENTS.md` does not exist, create the project's constitution before
proceeding. Establish the project's high-level guidelines and SDD/OKF
conventions first. Present to operator for review and approval.

### 2. Specify

This is the discussion and investigation phase. Work with the operator to
understand, explore, and record the intended change before implementation.

When exploring the current system, start with its existing specifications
documentation and change files. Then inspect the relevant code, tests, configuration, and
observed behavior. Existing artifacts provide context and may reveal
constraints, gaps, or contradictions that need to be resolved.

Together, the agent and operator should:

- understand the desired intent;
- explore the current system and its constraints;
- identify affected components;
- examine existing specifications and documentation;
- clarify scope and non-goals;
- resolve ambiguities;
- define acceptance criteria;
- record decisions;
- identify risks and open questions; and
- create or update the specification.

For new work, create a feature directory under `spc/`:

```text
spc/<feature-name>/spec.md
```

For changes, also create a change file, see the change files section below.

```text
spc/<feature-name>/yyyy/<change-id>.md
```

Choose a clear, stable feature name and place the specification and related
SDD artifacts there. Inspect `spc/` first to avoid creating a duplicate
feature directory. The first spec should be called spec.md, there can be
more than one such as: `this.spec.md`, `that.spec.md`.

All meaningful discussion and investigation should happen in this step. Later
steps execute and verify the results rather than silently reopening the same
discovery process. If implementation exposes a requirement conflict or a
change in intent, stop and return to the operator.

When working on an existing feature, update its spec.
It is expected to keep the spec updated as a reference throughout the lifetime of the project.

### 3. Plan

Capture the output of the discussion and investigation in a durable plan. The
plan is not a generic formula: it records the selected design, important
decisions, affected areas, dependencies, constraints, testing approach,
compatibility concerns, risks, and other conclusions that should guide
execution.

Check the plan against the specification before creating tasks.

### 4. Task

Break the plan into coherent units of work. Each task should be small enough
to review and merge independently where practical. Each task should become a
pull request.

Create a Markdown checklist in the feature directory, for example:

```text
spc/<feature-name>/tasks.md
```

Each checklist item must be followed by a short description of the work it
represents. Keep the checklist synchronized with the actual work and check
items off as they are completed.

```markdown
# Tasks

- [ ] Add the recovery data model — Store the token and expiry required by the recovery flow.
- [ ] Implement the recovery endpoint — Accept a verified email and issue a time-limited link.
- [ ] Add behavior tests — Cover successful recovery, expiry, reuse, and invalid addresses.
- [ ] Update documentation — Record the user-visible behavior and operational constraints.
- [ ] Open and review the pull requests — Submit each task as a focused PR and address review feedback.
```

### 5. Code

Implement the tasks according to the approved specification and plan.

- Follow the task checklist.
- Keep changes scoped to the specification.
- Add or update tests.
- Update the checklist as tasks are completed.
- Create the corresponding pull request for each task.
- Follow the project's normal review workflow.

This is an execution-focused step, not a second investigation phase. Do not
silently redesign the work. If the intended behavior must change, return to
the operator and update the specification and plan before continuing.

### 6. Ship

This step is primarily quality assurance. Verify the implementation
against the specification and acceptance criteria, run relevant tests and
checks, inspect the final diff, and confirm that the task checklist is
accurate.

- update affected documentation;
- update the specification when approved behavior changed;
- record unresolved follow-ups;
- confirm review and QA status; and
- ensure the SDD artifacts describe the work that was actually completed.

The operator might merge the work with a feature flag off for production,
shipping may happen later as a separate follow-up after implementation has
been merged, reviewed, and QA'd. The initial SDD workflow does not require
final production deployment.

## OKF frontmatter

SDD artifacts use OKF-style YAML frontmatter. The only required fields are:

```yaml
---
id: account-recovery
type: spec
summary: Describes account recovery behavior for members who cannot sign in.
author: Thom
created: 2026-09-11
---
```

- `id` short slug, words only.
- `type` always spec for specifications, documentation for documentation.
- `summary` short, machine friendly text.
- `author` identifies who provided the intent for the artifact.
- `agents` identifies agents involved in producing the artifact.
- `created` is the date the artifact was created.
- `updated` is the date the artifact was last updated.

`reviewed-by` is optional. Frontmatter may contain
any additional key/value pairs needed by the project.
Refs section should be a "kind: value" mapping containing links to other documents by ID or external references.
For pull requests, always use a URL and kind "PR".

## Specification example

A specification can be short when the behavior is simple:

```markdown
---
id: account-recovery
type: spec
summary: Describes account recovery behavior for members who cannot sign in.
author: thom
created: 2026-09-11
updated: 2026-09-15
agents: merlin
reviewed-by: []
---

# Account recovery

## Description

A member can request a recovery link using their verified email address. The
link expires after one hour and can be used only once.

## Refs

- PR: https://github.com/example/project/pull/184
```

## Documentation from existing implementation

A specification cannot be reliably written by reading code. Intent is
known before implementation; a document produced from code describes current
behavior and is documentation, not a specification.

When documenting an existing implementation:

1. Read the relevant specifications and documentation first.
2. Create or update the feature directory under `spc/`:

```text
spc/<feature-name>/
spc/<feature-name>/doc.md
```

The first doc should be called doc.md, there can be
more than one such as: `this.doc.md`, `that.doc.md`.

3. Inspect the code, tests, configuration, and observed behavior.
4. Describe what the system currently does.
5. Mark the artifact as documentation in the frontmatter:

```yaml
type: documentation
```

6. Do not present inferred intent as fact.
7. Request review and keep the documentation conceptually separate from a
   forward-looking specification.

## Staleness and drift

Incorrect documentation is worse than no documentation. When specifications,
documentation, and implementation disagree, the disagreement is a defect that
must be resolved.

Start by reading. Finish by updating.

At the beginning of work, read `AGENTS.md` and the relevant specifications and
documentation. At the end of work:

- check whether existing artifacts still describe reality;
- treat contradictions and missing documentation as defects;
- update affected specifications and documentation;
- keep the task checklist synchronized with actual work;
- record approved changes in the specification's changelog; and
- do not leave silent drift between intent, artifacts, and implementation.

## Evolution & structure

Changes are documented semantically one change per file for both humans and agents.
The files are organized in a directory with the current year under the feature, to avoid clutter.
This is a strategy to capture the semantic history of the project alongside the same repository versioning its implementation.
Releases.yaml maps change IDs to semantic versioning releases.

### changelog

The project changelog is a generated document meant to be readable by humans.
Each change file's body is meant to be added to the changelog.

```markdown
spc/
├── releases.yaml
│
├── account/
│ ├── spec.md
│ └── 2026/ <- change directory
│ ├── remove-avatar.md
│ └── ...
│
└── billing/
├── doc.md <- feature documented from implementation
└── 2026/
└── ...

CHANGELOG.md <- generated from releases.yaml and change files.

spec.md — current authoritative intent for the feature; continuously updated.
doc.md — current authoritative documentation for the feature; continuously updated.
YYYY/<slug>.md — immutable semantic change records.
releases.yaml — maps semantic changes into SemVer releases.
CHANGELOG.md — generated project-level projection; not the source of truth.
Git — retains the exact implementation history.
refs — connects the semantic change to external/provenance information such as PRs and related specs.
```

### change files

Changes are markdown files with OKF frontmatter.

Required fields:

- id: yyyy-mm-dd-<slug>.
- created: yyyy-mm-dd.
- summary: field is short, machine friendly text.
- description: markdown meant for the changelog for humans to read.
- type: conventional commit types: feat, fix, refactor, not limited to only these.
- - The chore type is not very semantic so prefer to specify instead of using it, chore -> infra.

The file should end with a Refs section to link to other artifacts by ID.
The PR number should go as a URL in refs.

```markdown
---
type: refactor
id: 2026-09-11-remove-avatar
created: 2026-09-11
summary: Remove avatar from UserProfile
---

# Remove avatar from UserProfile

## Description

UserProfile no longer accepts an avatar.

The avatar prop has been removed from UserProfile.

This eliminates the Avatar dependency and simplifies the profile
editing flow.

## Refs

- PR: https://github.com/example/project/pull/184
```

### releases

A minimum tracking file used to collect changes and programmatically build the project changelog.

```yaml
- version: 2.4.0
  date: 2026-09-15
  changes:
    - 2026-09-11-remove-avatar
    - 2026-09-12-bar
    - 2026-09-13-foo
```
