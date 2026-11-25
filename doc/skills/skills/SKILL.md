---
name: skills
description: Use when creating a new skill, editing an existing SKILL.md, or figuring out where skills live and how to find and read them.
---

# Writing & Reading Skills

A skill is a single `SKILL.md` file — YAML frontmatter plus a Markdown body of instructions. Skills
are plain text files in the interface repo, under `doc/skills/<name>/SKILL.md` on branch `dev`.
There is no registry or database: an agent finds a skill by listing the directory and reads it as a
file.

## SKILL.md Format

```markdown
---
name: my-skill
description: Use when the user asks to do X or mentions Y.
---

# Skill Title

Instruction body here — procedures, rules, examples, references.
```

### Frontmatter Fields

| Key           | Type   | Description                                                                                   |
| ------------- | ------ | --------------------------------------------------------------------------------------------- |
| `name`        | String | Kebab-case identifier. `^[a-z0-9][a-z0-9-]*$`. Stable — renaming breaks references.           |
| `description` | String | **Primary trigger signal.** Write as "Use when [specific situation]". Vague = under-triggers. |

`name` and `description` are required.

Keep the body focused and procedural: what to do, in what order, with concrete commands/examples.
Link out to other skills by name rather than duplicating their content.

## Finding and Reading Skills

If the interface repo is cloned, list `doc/skills/` and read the files directly. Otherwise, over
plain HTTP (no auth, the repo is public):

```bash
# list skill names
curl -s "https://api.github.com/repos/rthomazel/interface/contents/doc/skills?ref=dev" | grep '"name"'

# read one
curl -s https://raw.githubusercontent.com/rthomazel/interface/dev/doc/skills/github/SKILL.md
```

## Adding / Updating a Skill

Edit or create `doc/skills/<name>/SKILL.md` and open a pull request against `dev`. Once merged, the
file is the skill; there is nothing to publish.

## Conventions

- One `SKILL.md` per directory, directory name matches `name` in frontmatter.
- Write a fresh skill's `description` field first and sanity-check it triggers on the situations you
  intend — this is the only signal used for model-invoked selection.
- Prefer editing an existing skill over creating a near-duplicate; consolidate overlapping skills.
