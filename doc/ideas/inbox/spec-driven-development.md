# SDD

The name of the engineering practice becoming popular in 25, 26 is spec-driven development where Humans write markdown specification of engineering intent and then hand over to AI agents for implementation.
There are steps: specify, plan, tasks and implementation.
Markdown Knowledge Graph Is an organization strategy that links markdown files together making them easy to navigate for humans and agents, saving context.

So from basic to auxiliary, Markdown as the file format, English as the language, use OKF (Open Knowledge Format) in everything.
You only stand to gain from this, Machine readable, organizable, extensible.
Save everything in git, review and commit in the repository Alongside the code.
Existing markdown files can be left alone but should be given an OKF front matter.
I think SDD is only for specs and OKF Markdown can be anything, not just specs.
SDD is a methodology for writing markdown files describing implementation.
Specs should live in the SPC/ directory.

> OKF spec https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md

Specifications cannot be reversed engineered from current implementation code.
Intent is only known before implementation, so a document made from code is documentation.
They should be marked in their metadata reverse-engineered: true.
Reverse engineered docs should be reviewed carefully and focus on the current behavior.
Besides different names and different metadata, specs and documentation are essentially the same.
However, it's important not to confuse the two and keep them conceptually separate.
Existing documentation just needs the addition of a front matter.

- Markdown -> representation.
- English -> human/agent-readable content.
- OKF -> lightweight structure/metadata convention.
- wikilinks -> navigation.
- frontmatter -> relationships.
- software metadata -> more nuanced relationships between spec files in the frontmatter.
- Git -> persistence/history/review.
- Graph -> derived structure.
- IWE -> tooling over the structure, visual graph navigation.
- SPC/ -> location/convention for specifications.
- SDD -> methodology for creating and maintaining specifications.
- Agent/Human -> consumer/producer of all of the above.

> Reading list in order
>
> - [x] https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html
> - [ ] https://www.thoughtworks.com/en-br/insights/blog/agile-engineering-practices/spec-driven-development-unpacking-2025-new-engineering-practices
> - [ ] https://www.thoughtworks.com/radar/techniques/spec-driven-development
> - [ ] https://github.com/github/spec-kit/blob/main/README.md
> - [ ] https://kiro.dev/blog/from-chat-to-specs-deep-dive/

| Artifact      | Kind                          |
| ------------- | ----------------------------- |
| Spec          | Intent, behavior, description |
| Documentation | Software behavior, no intent  |

```
# SDD workflow

Constitution, markdown file with high level guidelines
    -> is read as a starting point to
Specify, describe behavior and intent of a change to the software
    -> refine iterate explore and organize into
Plan, an organized and validated document of intent, behavior and decisions
    -> review and analyze, then subdivide into
Tasks, steps to implement a plan, in logical order
    -> implemented by agents
Code, reviewed and iterated by the team
    -> spec author performs quality assurance and review
Ship
```

### metadata

Front matter metadata should be used to enrich documents.
Nuanced software relationships between files, Implemented by, Superseeds, Consumer.
Fields like author, reviewed-by can help identify the type of artifact, specs will mostly be human authored.
Fields like status can support files in different stages of maturity.
An ID field can be added to frontmatter to make the relationships resilient to moves and renames, in this case, front matter relationship should reference by ID.

#### changelog

Specs and documentation should end with a changelog.
Format: `## Changelog`
Followed by: "```yaml"
Entries:

```yaml
- date: yyyy-mm-dd
  type: string enum
  summary: string
  refs: []string
```

Tracks the history, evolution and lifecycle of a spec.
YAML is chosen to make it parsable and easy to search for.

## Software modelling

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
It uses pseudo-code language, to keep it agnostic from any given programming stack.
Models are colocated with the code file, same path, `.model.md` extension, one per file.
Note: experiment with a model per group of files.
Trivial function implementations should be omitted or be just english when non-trivial.
Async mechanisms, concurrency, library details and black magic should be documented as prose in the relevant function.
After elaboration the model documents are then reviewed and saved together with the code.

todo: Define language to represent code in models

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
|               |                     |         |
|               ______________________          |
|                        Spec                   |
|                        ↓                      |
|                        Plan                   |
|                        ↓                      |
|                        Tasks                  |
|                        ↓ ↓ ↓ ...              |
|                        Models                 |
|                        ↓ ↓ ↓ ...              |
|                        Code                   |
|                        ↓                      |
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

### tools

- github.com/iwe-org/iwe

#### Tooling opportunities

- Automatic generation and verification of model files, synchronization, extraction.
- Lookup map of relationships by ID.

## workflows

### foundation

- add a spc/ directory.
- adopt OKF frontmatter for all files.
- human writes spc/constitution.md with high level guidelines.
- define your OKF metadata fields and rules in the constitution.
- organize spec files by feature directories.
- add a model sub directory to each feature to house implementation details.

### new work

- human and agent write rough spec files after discussing behavior and design with non technical folks.
- work through SDD steps, constitution, spec plan tasks code ship.
- agent generates model after final QA'd code.
- human reviews model

### documentation from code

- agent reads code for a feature and/or reviews documentation.
- produces a reverse-engineered doc for review, adds proper metadata.
- human review, discussion.
- doc is commited.
- agents generates models.
- human reviews.

### spec change

- same as new work but mostly updating existing specs and models
