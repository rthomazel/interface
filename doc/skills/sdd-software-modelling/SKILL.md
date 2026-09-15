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

## Model syntax rules

Generic

- File naming: `<basename>.model.md`, replacing the source extension entirely — `response.go` → `response.model.md`.
  Models are colocated with the code file, same path, `.model.md` extension, one per file.
- Language: a terser representation of the implementation's language, up to the author. Drop keywords, import and anything that detracts from the semantics.
  It's agnostic enough to be independent, but familiar to the coders and the code.
- Types: type keywords folowed by name, no tags and fields as a numbered list; Add other details as prose.
- Constants: name = value, with any derived or notable behavior as a trailing clause or prose.
- Avoid: code fences, backtick-wrapped identifiers, quoted string literals, Refs section
- Format strings use `{Field}` placeholders.

Functions

- Signatures, always name arguments and return values.
- Use `Receiver.Method(args) returnType` for receiver methods.
- Trivial implementations are one line — a signature followed by a single prose sentence describing what it does.
- Functions calls use the actual function name, followed by ().
- Non-trivial function bodies are a numbered step list, one step per line.
- Branches are nested sub-steps, indented, phrased `if <condition>, <action>, <action> ...`.
- Rationale and non-obvious behavior are prose paragraphs below the step list, never inline comments.
- Sub-step numbering restarts at 1 under each parent step; indentation carries the grouping.
- Describe control structures like loops by their effect.
  Complex loops may reference an earlier step directly: repeat from step N.

## Example 1 — `response.model.md`

```
type errorResponse

1. Error string
2. Message string

Message is omitted from the response when empty.

writeError(w ResponseWriter, status int, code string, message string)

Builds an errorResponse{code, message} and calls writeJson().

writeJson(w ResponseWriter, status int, v any)

1. Set Content-Type: application/json.
2. Write the status header.
3. Encode v as JSON into the response body.

Step 3's encoding errors are discarded, not surfaced to the caller. By the
time step 3 runs, the status header is already written (step 2), so the
response is committed — there is no correction path left, only a partially
sent body. This is intentional, not an oversight.

handleGetAccount(w ResponseWriter, r *Request)

1. Parse the account ID from the request path.
   1. if parse failure, call writeError(400, invalid_id), return.
2. Look up the account by ID in the store.
   1. if not-found, call writeError(404, not_found), return.
   2. if store error, call writeError(500, internal_error), return.
3. Call writeJson(200, account).
```

## Example 2 — `event.model.md`

```
eventWorkerInterval = 5s
baseBackoff = 30s, doubles per handler failure, capped at 2^9 (~4.5h)

type EventWorker

1. store Store
2. handlers map[string][]Handler
3. interval Duration

NewEventWorker(store Store, handlers map[string][]Handler) *EventWorker

Builds an EventWorker with store, handlers, and interval set to eventWorkerInterval.

EventWorker.Run(ctx Context)

1. Call processOnce().
2. Wait for ctx to be cancelled or the next tick.
   1. if ctx is cancelled, return.
   2. if the tick fires, repeat from step 1.

ProcessOnce runs synchronously here — a run that takes longer than interval
delays the next tick rather than overlapping with it. Ticks that arrive while
still processing are dropped, not queued, so a slow pass never causes a burst
of catch-up runs afterward.

EventWorker.ProcessOnce(ctx Context)

1. Call listPendingEvents() on the store.
   1. if it fails, log and return.
2. Call processEvent() for each pending event.

EventWorker.processEvent(ctx Context, event *Event)

1. Look up the handlers registered for event.Type.
   1. if there are none, return.
2. Run each handler not already marked successful on this event.
   1. if the handler already succeeded for this event, skip it.
   2. if the handler fails, log the error, call recordHandlerFailure() to schedule a retry, mark the event incomplete, continue.
   3. if recordHandlerSuccess() fails, log the error, mark the event incomplete, continue.
   4. mark the handler successful on the event.
3. if every handler succeeded, call completeEvent().
   1. if it fails, log the error.

A failed handler's retry delay is baseBackoff doubled once per prior failure
on the event, capped at 9 doublings. Retries are per-handler: a handler that
already succeeded is skipped on the next pass even if other handlers on the
same event are still failing.
```
