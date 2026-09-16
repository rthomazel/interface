---
name: sdd-software-modelling
description: Use when requested to work with software models, create or update them, or when the user mentions software modelling.
---

# SDD: Spec-Driven Development Software Modelling

> This skill builds upon the SDD spec drive development skill, it's a mandatory read if you haven't already.

A methodology that represents the implementation structure in markdown files.
Software models enable reasoning about the program without excessive details.

#### Motivation

- Enrichment: Complement the spec with the implementation's design, providing documentation for maintenance and usage.
- Enhanced navigation: Agents and humans can navigate the software at a middle level quickly
- Code as byproduct: The source code becomes a representation of the model.
- Human review: Developers can review most changes in natural language, looking at code only when necessary.
- Flexibility: Specs, changes and the software model enables re-implementation in another stack.
- Utility: The software can be extended and redesigned with confidence.

#### Spec vs models

Information should not repeat between the two.
Specs should contain intention, decisions, motivations, use cases, behavior, constraints, concepts and knowledge.

- Software patterns
- System architecture
- Data storage
- Data flows

Models should contain schemas, structure, implementation notes and details.

- Schema
- Types
- File names
- Function signatures
- Error handling flows
- API surface
- Classes
- Edge cases
- Implementation complexity

### Models

Always produce models before code and after specs.
Only produce code after the model is approved.
After elaboration the model documents are then reviewed and saved together with the code.

```
SRC/
├── account/
│   ├── UserProfile.model.md
│   ├── UserProfile.ts
│   └── ...
│
└── billing/
    ├── BillingService.model.md
    ├── BillingService.ts
    └── ...
```

### SDD workflow, including requirements and modelling

Models are done per task.

```
|        non technical         |    technical   |
|------------------------------|----------------|
| Intent, Requirements, Design |  Constitution  |
|               ↓                     ↓         |
|               ----------------------          |
|                        Spec                   |
|                         ↓                     |
|                        Plan                   |
|                         ↓                     |
|                        Tasks                  |
|                        ↓ ↓ ↓ ...              |
|                        Models                 |
|                        ↓ ↓ ↓ ...              |
|                        Code                   |
|                          ↓                    |
|                        Ship                   |
```

| level   | file       | language             |
| ------- | ---------- | -------------------- |
| high    | spec       | english              |
| middle  | model      | english, pseudo code |
| low     | code       | programming          |
| machine | executable | machine              |

## Staleness

Special attention is necessary with model files since they are middle level.
These documents drift from code more frequently.
Regular software engineering workflows, like bug fixes, should always review model files and make updates.
Continuous integration of documentation and models against the code they document is strongly encouraged.

- Incorrect models are bugs, worse than no model
- CI check required models to be updated when a code file is updated
- PRs start by changing only models first, for a clean diff, followed by code in the same PR.

## Model syntax rules (Go)

Generic

- File naming: `<basename>.model.md`, replacing the source extension entirely — `response.go` → `response.model.md`.
  Models are colocated with the code file, same path, `.model.md` extension, one per file.
- Language: a terser representation of the implementation's language, up to the author. Drop keywords, import and anything that detracts from the semantics.
  It's agnostic enough to be independent, but familiar to the coders and the code.
- Structure: top-level headings, in this order: Constants, Vars, Types, Interfaces, Functions each
  present only if the file has content for it. Each var, type, interface, or function gets its own H2 under its section.
  Constants stay a flat list under one # Constants heading. A function or method's heading is its full signature verbatim.
- Types: type keywords folowed by name, no tags and fields as a numbered list; Add other details as prose.
- Constants: name = value, with any derived or notable behavior as a trailing clause or prose.
- Interfaces: H2 heading is the interface name, list its methods as a numbered list, same signature format as a function, no receiver. Add other details as prose.
- Vars: A var's H2 heading is Name = value for a single value (e.g. a sentinel error), or just Name when it's a registry of several values (e.g. a struct literal grouping related constants).
- Avoid: code fences, backtick-wrapped identifiers, quoted string literals in prose, Refs section.
  For constants and vars when the value itself is a string, quote it.
- Format strings use `{Field}` placeholders.
- These rules are not exhaustive. When a construct doesn't fit them,
  invent notation that stays terse and unambiguous in context rather than forcing it into an ill-fitting rule.

Functions

- Signatures, always name arguments and return values.
- Use `Receiver.Method(args) returnType` for receiver methods.
- Trivial implementations are one line — a signature followed by a single prose sentence describing what it does.
- Functions calls use the actual function name, followed by ().
- Non-trivial function bodies are a numbered step list, one step per line.
- Branches are nested sub-steps, indented, phrased `if <condition>, <action>, <action> ...`.
- Sub-step numbering restarts at 1 under each parent step; indentation carries the grouping.
- A child number (`.N` appended to a step) is only used when that branch is reachable
  exclusively through the parent's own outcome — nested inside it in the actual code.
  Independent outcomes of the same statement stay at the same depth.
- When a function has enough failure branches that inlining them clutters the happy path, pull
  them into an H4 Errors subsection below the step list instead: a bullet list, one bullet per
  branch, each bullet's number matching the happy-path step it attaches to (`1.`, `1.2.`, `1.2.1.`
  for a branch nested under step 1.2). Separate each group of bullets that share a leading step
  number with a `---` divider, so branches attached to different steps read as visually distinct
  groups. Keep inline nested branches for functions with only one or two simple guard clauses;
  reserve the H4 Errors split for functions where the branching is the point.
- Describe control structures like loops by their effect.
  Complex loops may reference an earlier step directly: repeat from step N.
- Rationale and non-obvious behavior are prose paragraphs below the step list, never inline comments.

## Example — `queue_entry.model.md`

```
# Constants

postgresForeignKeyViolation = "23503", the Postgres SQLSTATE code for a foreign key violation.

insertQueueEntrySQL = insert a queue_entries row, ON CONFLICT (client_id, retry_key) DO NOTHING, returning the full row.
findQueueEntryByClientRetrySQL = select the full row by (client_id, retry_key).

# Vars

## ErrInvalidTransition = "invalid state transition"

Returned when a state transition is attempted from a status that doesn't allow it, e.g.
completing an entry that isn't in_progress.

## ErrInvalidEnumValue = "invalid enum value"

Returned when a text field is set to a value outside its app-layer validated enum. These columns
are text in Postgres, not native enums, so validation lives here.

## Events

1. Events.QueueEntry.Created = "queue_entry.created"
2. Events.QueueEntry.StatusChanged = "queue_entry.status_changed"
3. Events.QueueEntry.PatientLinked = "queue_entry.patient_linked"

Grouped so callers reference domain.Events.QueueEntry.StatusChanged instead of hard-coding string
literals.

# Types

## queueEntryRow

1. ID UUID
2. ClientID UUID
3. RetryKey string
4. PatientID *string
5. StaffID *UUID
6. Status string
7. PatientCreationStatus string
8. Demographics RawMessage
9. CreatedAt Time
10. StartedAt *Time
11. CompletedAt *Time
12. CancelledAt *Time
13. CancellationReason *string
14. CancellationNote *string

# Interfaces

## TokenStore

1. Issue(ctx Context, queueEntryID UUID, ttl Duration) (token string, err error)
2. Redeem(ctx Context, token string) (queueEntryID UUID, ok bool, err error)

Redeem is single-use: ok is false if the token doesn't exist or was already redeemed. Implemented
by RedisTokenStore, backed by Redis GETDEL.

# Functions

## queueEntryRow.toDomain() *domain.QueueEntry

1. Build a domain.QueueEntry from the row's fields, converting Status and PatientCreationStatus to their domain enum types.
2. if CancellationReason is set, convert it to domain.CancellationReason and assign.
3. if Demographics is non-empty, unmarshal it into the entry's Demographics field, discarding any error.
4. Return the entry.

## Store.withTx(ctx Context, fn func(tx *Tx) error) error

1. Begin a transaction.
2. Call fn with the transaction.
3. Commit the transaction.
4. Return nil.

#### Errors

- **1.** if beginning fails, return the wrapped error.

---

- **2.** if fn fails, roll back.
- **2.1.** if the rollback also fails, return both errors combined.
- **2.2.** otherwise, return fn's original error.

---

- **3.** if committing fails, return the wrapped error.

## Store.AdmitQueueEntry(ctx Context, entry *QueueEntry) (*QueueEntry, bool, error)

1. Run inside withTx:
   1. Lock the queue state row.
   2. Confirm the queue is open.
   3. Marshal entry.Demographics to JSON.
   4. Insert the row via insertQueueEntrySQL, scanning the result. Mark created.
   5. Insert a queue_entry.created event for entry.ID.
   6. Convert the row to a domain entry and store it as the result.
2. Return the result, created, and nil.

#### Errors

- **1.1.** if locking fails, return the error.

---

- **1.2.** if the open check fails, return the error.
- **1.2.1.** if the queue is closed, return ErrQueueClosed.

---

- **1.3.** if marshalling fails, return the wrapped error.

---

- **1.4.** if the insert returned no rows (ON CONFLICT hit an existing row), fetch the existing row via findQueueEntryByClientRetrySQL instead of treating it as created.
- **1.4.1.** if that fetch fails, return the wrapped error.
- **1.4.2.** if the insert failed with a foreign key violation instead, return ErrClientNotFound.
- **1.4.3.** if the insert failed for any other reason, return the wrapped error.

---

- **1.5.** if the created event insert fails, return the error.

---

- **2.1.** if withTx returned an error, return nil, false, and the error.

ON CONFLICT (client_id, retry_key) DO NOTHING makes admission idempotent under retries (see
doc/design.md, "Admission Retry Safety"): a retry with the same client and retry key returns the
entry's actual current state (step 1.4) rather than erroring or duplicating it.
```
