---
name: sdd-change-management
description: Use when recording semantic implementation changes, maintaining SDD change files, generating changelogs, or tracking releases with releases.yaml.
---

# SDD: Change Management

Use this skill with the SDD base skill when a project chooses to maintain semantic
change records, a generated changelog, or release tracking. These artifacts are
optional to spec-driven development itself.

## Structure

```text
spc/
├── releases.yaml
│
├── account/
│ ├── spec.md
│ └── 2026/ <- change directory
│    ├── remove-avatar.md
│    └── ...
│
└── billing/
   ├── doc.md
   └── 2026/

CHANGELOG.md <- generated from releases.yaml and change files.
```

- `spec.md` is current authoritative intent.
- `doc.md` is current authoritative documentation of existing behavior.
- `YYYY/<slug>.md` records one semantic change, not necessarily one task or PR.
- `releases.yaml` maps semantic changes to SemVer releases.
- `CHANGELOG.md` is a generated, human-readable projection; it is not the source of truth.
- Git retains exact implementation history.
- Refs connect artifacts to related specs and external provenance.

## Change files

Create the change file during the Code step, after implementation has stabilized.
This avoids repeatedly rewriting a forward-looking record while intent and design
are still being refined. Update it as review or implementation changes the final
semantic description.

Each change file uses OKF frontmatter:

```yaml
---
type: change
subtype: refactor
id: 2026-09-11-remove-avatar
created: 2026-09-11
summary: Remove avatar from UserProfile
---
```

Required fields:

- `id`: `yyyy-mm-dd-<slug>`; the date provides sorting and uniqueness.
- `created`: `yyyy-mm-dd`.
- `type`: `change`.
- `summary`: short, machine-friendly text.
- `subtype`: semantic conventional-commit style such as `feat`, `fix`, `refactor`, or `infra`.

Prefer a semantic subtype over `chore`, which is too vague. The body should
explain the user-visible or engineering-significant change in human-readable
Markdown. End with a Refs section. PR references must be URLs.

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

UserProfile no longer accepts an avatar. The avatar prop has been removed,
eliminating the Avatar dependency and simplifying profile editing.

## Refs

- PR: https://github.com/example/project/pull/184
```

## Releases

`releases.yaml` collects artifact IDs for programmatic changelog generation.
Any artifact type with an ID may be included:

```yaml
- version: 2.4.0
  date: 2026-09-15
  refs:
    - 2026-09-11-remove-avatar
    - 2026-09-12-bar
    - 2026-09-13-foo
```

The project-specific command or workflow that generates `CHANGELOG.md` is
intentionally outside this skill and must be documented by the project.
