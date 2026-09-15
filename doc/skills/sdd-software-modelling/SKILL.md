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
It uses a terser representation of the implementation's language, up to the author;
It's agnostic enough to be independent, but familiar to the coders and the code.
Models are colocated with the code file, same path, `.model.md` extension, one per file.
Note: experiment with a model per group of files.
Trivial function implementations should be omitted or be just english when non-trivial.
Async mechanisms, concurrency, library details and black magic should be documented as prose in the relevant function.
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

## Model syntax rules

Generic

- File naming: `<basename>.model.md`, replacing the source extension entirely — `response.go` → `response.model.md`.
- Language: terser version of the source file's own language, per-project choice. Drop keywords, import and anything that detracts from the semantics.
- Types: remove keywords and tags, fields as a numbered list; Add other details as prose.
- Avoid: code fences, backtick-wrapped identifiers, quoted string literals, Refs section
- Format strings use `{Field}` placeholders.

Functions

- Focus on signatures, always name arguments and return values. `Receiver.Method(args) returnType` dot notation.
- Trivial implementations are one line — a signature followed by a single prose sentence describing what it does.
- Non-trivial function bodies are a numbered step list, one step per line.
- Branches are nested sub-steps, indented, phrased `if <condition>, <action>, <action> ...`.
- Rationale and non-obvious behavior are prose paragraphs below the step list, never inline comments.
- Sub-step numbering restarts at 1 under each parent step; indentation carries the grouping.
- Describe control structures like loops by their effect.

## Example 1 — `response.model.md`

```
errorResponse

1. Error string
2. Message string

Message is omitted from the response when empty.

writeError(w ResponseWriter, status int, code string, message string)

Builds an errorResponse{code, message} and delegates to writeJSON.

writeJSON(w ResponseWriter, status int, v any)

1. Set Content-Type: application/json.
2. Write the status header.
3. Encode v as JSON into the response body.

Step 3's encoding errors are discarded, not surfaced to the caller. By the
time step 3 runs, the status header is already written (step 2), so the
response is committed — there is no correction path left, only a partially
sent body. This is intentional, not an oversight.

handleGetAccount(w ResponseWriter, r *Request)

1. Parse the account ID from the request path.
   1. if parse failure, writeError(400, invalid_id), return.
2. Look up the account by ID in the store.
   1. if not-found, writeError(404, not_found), return.
   2. if store error, writeError(500, internal_error), return.
3. Write the account as JSON, status 200.
```

## Example 2 — `queue_entry_slack_notification_handler.model.md`

```
QueueEntrySlackNotificationHandler.Handle(ctx Context, event *Event) error

1. Parse the queue entry id from event.Data["id"].
   1. if parse fails, log and return nil.
2. Find the queue entry by id in the store.
   1. if not found, log and return nil.
3. Normalize the entry's email: trim whitespace, fold case.
4. Check the normalized email against the handler's ignored list.
   1. if the email contains any ignored entry, log and return nil.
5. Build the notification text: New walk-in queue patient: {FirstName} {LastName} ({Email}).
6. Post the message to the notifier.
   1. if the post fails, log the error.
7. Return nil.

Handle never returns a non-nil error. The notification is best-effort: every
failure path (a malformed id, a missing entry, an ignored email, a failed
post) logs and returns nil rather than propagating the error. This matters
because the caller treats a returned error as a retry signal — this
notification should never be retried, so failure here is deliberately
invisible to the caller.
```
