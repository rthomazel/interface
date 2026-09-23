---
name: sdd-spec-driven-development
description: Use when requested a specification or asked to plan and implement non-trivial software work using spec-driven development.
---

# SDD: Spec-Driven Development

Spec-driven development (SDD) is an engineering practice in which specifications describe engineering intent and guide implementation by both agents and people.
The work is recorded in Markdown, written in English, structured with [Open knowledge format (OKF)](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md) frontmatter, and kept in Git alongside the code.

- **Markdown** is the representation.
- **English** is the human- and agent-readable content.
- **OKF** provides lightweight structure and metadata.
- **Git** provides persistence, history, review, and collaboration.
- **`spc/`** is the location for specifications and related SDD artifacts.

A specification describes intended behavior and engineering intent.
It is not a report reconstructed from an existing implementation.
Human operators and agents may write, refine, and maintain specifications;
human resolves unresolved questions of intent and scope.

## Workflow

The default path is Spec → Models → Code → QA. Read `AGENTS.md` and relevant
artifacts first. Feedback returns to the affected phase, not the start of the workflow.

```text
Spec → Models → Code → QA
  ↑       ↑       ↑     │
  └───────┴───────┴─────┘ feedback
```

Use the smallest artifact change and review cycle sufficient for the work.
For a simple change, aim for one model review cycle before implementation, not
separate approvals for every artifact or workflow step. Operator-provided intent
and implementation decisions are established input: bring them up again only
when confusing or conflicting with constraints. Carry implementation decisions
into models rather than restating them in task descriptions or asking for approval again.
Present the changed design, not a repeated explanation of the unchanged feature.
Update existing artifacts where necessary; do not create redundant summaries,
plans, or checklists. Keep appropriate verification even when narration is brief.

### 1. Read `AGENTS.md`

For SDD purposes, the project constitution is the repository's `AGENTS.md`.
It contains the high-level guidelines, constraints, conventions, and
expectations that govern work across the project.

Read it before doing SDD work.

If `AGENTS.md` does not exist, create the project's constitution before proceeding.
Establish the project's high-level guidelines and SDD/OKF conventions first.
Present to operator for review and approval.

### 2. Specify

This is the discussion and investigation phase.
Work with the operator to understand, explore, and record the intended change before implementation.
When exploring the current system, start with its existing specifications documentation and change files.
Then inspect the relevant code, tests, configuration, and observed behavior.
Existing artifacts provide context and may reveal constraints, gaps, or contradictions that need to be resolved.

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

- The spec is not a technical document, avoid code and code references, document and discuss logical concepts in prose.
- Choose a clear, stable feature name and place the specification and related SDD artifacts there.
  Inspect `spc/` first to avoid creating a duplicate feature directory.
  The first spec should be called spec.md, there can be more than one such as: `this.spec.md`, `that.spec.md`.
- Resolve intent and scope here; resolve software structure during modelling.
  Discussion and investigation happen in both phases. Modelling may expose
  questions that require revisiting the specification.
- If implementation exposes a requirement conflict or a change in intent, stop and return to the operator.
- When working on an existing feature, update its spec.
  It is expected to keep the spec updated as a reference throughout the lifetime of the project.

### 3. Models

Use the `sdd-software-modelling` skill to create or update models for a coherent
change. Models are the primary technical review artifact: software structure,
schemas, signatures, algorithms, and error flows belong there, not in tasks.
Discuss and resolve design questions during this phase. Present the model diff
for human approval before implementing it; larger work can repeat this cycle in
independently understandable increments.

### 4. Code

Implement according to the specification and approved models.

- Keep changes scoped to the specification.
- Add or update tests.
- Follow the project's normal PR and review workflow.
- Keep optional delivery coordination artifacts synchronized when used.
- Update change files with PR refs when used.

Do not silently redesign the work. If implementation exposes a design problem,
revise the affected model and seek approval for the changed design. If intent or
scope must change, return to the operator and update the specification first.
Routine coding details within the approved model do not require another approval.

### 5. QA

Before handing off, the agent verifies the implementation against the specification,
models, and acceptance criteria, runs relevant tests and checks, and inspects the
final diff. Passing these checks means ready for operator QA, not QA complete.

The operator exercises the software and brings feedback. Iterate at the affected level:

- Implementation differs from the approved model: fix code and verify.
- Software design needs adjustment: update the model, review the change, then code.
- Intended behavior or scope changes: update the spec, then affected models and code.

Update affected documentation and approved intent/design changes, record unresolved
follow-ups, and report actual check and operator QA status. Ensure artifacts reflect
the completed work; confirm checklist accuracy only when a checklist is used.

Merging and production deployment are separate from this QA loop. Work may be
merged behind a disabled feature flag and deployed later; this workflow does not
require final production deployment.

## Optional delivery coordination

**Specs and models describe the software. Plans and tasks organize the work.
Organizing the work must not become a prerequisite for reviewing the software.**

Do not create plans or tasks by default. Neither is a prerequisite for modelling
or implementation, and they do not introduce mandatory approval rounds. Use them
when the operator requests them or when they solve the delivery needs below.
Technical design belongs in models; coordination artifacts reference those models
rather than duplicating schemas, signatures, algorithms, or error handling.

### Plan

Use a plan when the work is large and needs breaking into coherent delivery stages,
or when requested by the operator. Record stage goals, dependencies, and delivery
risks, including rollout sequencing when relevant. A plan does not require a separate
task document.

```text
spc/<feature-name>/plan.md
```

### Tasks

```text
spc/<feature-name>/tasks.md
```

Use tasks when work will be held for later or implemented in batches, or when
requested by the operator. `tasks.md` records remaining work and its order, with
references to the relevant models rather than implementation details.

Break the plan, or the small specification, into coherent units of work.
Each task should be small enough to review and merge independently where practical.
As guidance, prefer one focused pull request per task when that improves reviewability,
but group tightly coupled tasks into one pull request when splitting them would add noise or make the work harder to understand.

When used, create `tasks.md` in the feature directory.
Each item should be an H2 with a number and checkbox, followed by a brief scope
description and references to the relevant models.
Keep the tasks synchronized with the actual work and check items off as they are completed.
Include PR links as refs.
Avoid an actual markdown ul/li list.

```markdown
# Tasks

## [ ] 1. Add the recovery data model

Implement the approved recovery storage model. See the affected storage model file.

## [ ] 2. Implement the recovery endpoint

Implement the approved recovery handler model. See the affected handler model file.
```

## OKF frontmatter

SDD artifacts use OKF-style YAML frontmatter. The only required fields are:

```yaml
---
id: 2026-09-11-account-recovery
type: spec
summary: Describes account recovery behavior for members who cannot sign in.
author: Thom
created: 2026-09-11
---
```

- id: yyyy-mm-dd-<slug>.
- `type` always spec for specifications, documentation for documentation, change for change files.
- `summary` short, machine friendly text.
- `author` identifies who provided the intent for the artifact.
- `created` is the date the artifact was created.

optional fields:

- `agents` comma separated string. Identifies agents involved in producing the artifact.
- `updated` is the date the artifact was last updated.
- `reviewed-by` names of individuals or agents who reviewed the artifact.

Frontmatter may contain any additional key/value pairs needed by the project.
Refs section should be a "kind: value" mapping containing links to other documents by ID or external references.
For pull requests, always use a URL and kind "PR".

## Specification example

A specification can be short when the behavior is simple:

```markdown
---
id: 2026-08-23-account-recovery
type: spec
summary: Describes account recovery behavior for members who cannot sign in.
author: Thom
created: 2026-09-11
updated: 2026-09-15
agents: merlin, rook2
reviewed-by: Thom
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
- keep the task checklist synchronized with actual work, when used;
- record approved changes in the specification's changelog; and
- do not leave silent drift between intent, artifacts, and implementation.

## Evolution & structure

Specifications and implementation documentation are maintained as living artifacts.
For semantic change records, changelogs, and release tracking, use the separate
change-management skill. Those artifacts are optional to spec-driven development itself.

### Change files

Changes are markdown files with OKF frontmatter.
Each file should capture one change, not necessarily one unit of work.

Required fields:

- id: yyyy-mm-dd-<slug>. Year is repeated for sorting and uniqueness. Slug is a short, machine-friendly description of the change.
- created: yyyy-mm-dd.
- type: change.
- summary: field is short, machine friendly text.
- description: markdown meant for the changelog for humans to read.
- subtype: conventional commit types: feat, fix, refactor, not limited to only these.

The chore subtype is not very semantic so prefer to specify instead of using it, chore -> infra.
The file should end with a Refs section to link to other artifacts by ID.
The PR number should go as a URL in refs.

```markdown
---
type: change
subtype: refactor
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

### Releases

A minimum tracking file used to collect refs and programmatically build the project changelog.
Any type of artifact with an ID can be included.

```yaml
- version: 2.4.0
  date: 2026-09-15
  refs:
    - 2026-09-11-remove-avatar
    - 2026-09-12-bar
    - 2026-09-13-foo
```
