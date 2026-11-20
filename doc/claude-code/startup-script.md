#!/bin/bash

mkdir -p /root/.claude/hooks

cat > /root/.claude/settings.json <<'EOF'
{
  "attribution": {
    "commit": "",
    "pr": "",
    "sessionUrl": false
  },
  "permissions": {
    "defaultMode": "bypassPermissions"
  },
  "autoCompactWindow": 400000,
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup|compact",
        "hooks": [
          {
            "type": "command",
            "command": "bash /root/.claude/hooks/git-bot-signing.sh"
          },
          {
            "type": "command",
            "command": "bash /root/.claude/hooks/load-context.sh"
          }
        ]
      }
    ]
  }
}
EOF
cat > /root/.claude/hooks/git-bot-signing.sh <<'EOF'
#!/bin/bash
set -euo pipefail

# Configures git to sign commits with a dedicated bot SSH key, kept separate
# from the user's personal identity. Signing only -- this key is never added
# to ssh-agent and never used as an IdentityFile for git remote auth.

if [ -z "${SSH_BOT_KEY:-}" ]; then
  exit 0
fi

# The platform pre-configures gpg.ssh.program to its own proprietary binary
# (/tmp/code-sign). We don't know whether it honors an arbitrary signingkey
# path, so we don't rely on it -- we install the real ssh-keygen and point
# gpg.ssh.program at it explicitly, giving predictable, documented signing
# behavior using only our own bot key.
if ! command -v ssh-keygen >/dev/null 2>&1; then
  apt-get update -qq && apt-get install -y -qq openssh-client
fi
SSH_KEYGEN_BIN="$(command -v ssh-keygen)"

KEY_DIR="/root/.ssh/bot-signing"
KEY_FILE="$KEY_DIR/id_ed25519"
PUB_FILE="$KEY_FILE.pub"
ALLOWED_SIGNERS="$KEY_DIR/allowed_signers"

mkdir -p "$KEY_DIR"
chmod 700 "$KEY_DIR"

umask 077
# SSH_BOT_KEY is base64-encoded (single-line, safe against env-var newline
# flattening); decode it back to the real PEM-formatted private key.
printf '%s' "$SSH_BOT_KEY" | base64 -d > "$KEY_FILE"
chmod 600 "$KEY_FILE"

"$SSH_KEYGEN_BIN" -y -f "$KEY_FILE" > "$PUB_FILE"
chmod 644 "$PUB_FILE"

# GIT_BOT_EMAIL/GIT_BOT_NAME are set explicitly alongside SSH_BOT_KEY so the
# signer identity is deterministic, independent of whatever user.name/email
# happen to be set to at hook run time.
SIGNER_EMAIL="${GIT_BOT_EMAIL:-$(git config --global user.email || echo "bot@localhost")}"
printf '%s %s\n' "$SIGNER_EMAIL" "$(cat "$PUB_FILE")" > "$ALLOWED_SIGNERS"

git config --global gpg.format ssh
git config --global gpg.ssh.program "$SSH_KEYGEN_BIN"
git config --global user.signingkey "$KEY_FILE"
git config --global commit.gpgsign true
git config --global gpg.ssh.allowedSignersFile "$ALLOWED_SIGNERS"

if [ -n "${GIT_BOT_NAME:-}" ]; then
  git config --global user.name "$GIT_BOT_NAME"
fi
if [ -n "${GIT_BOT_EMAIL:-}" ]; then
  git config --global user.email "$GIT_BOT_EMAIL"
fi

# Explicitly keep this key out of remote auth: not added to ssh-agent,
# not referenced in ~/.ssh/config as an IdentityFile.
EOF

cat > /root/.claude/stop-hook-git-check.sh <<'EOF'
#!/bin/bash
:
EOF


cat > /root/.claude/hooks/load-context.sh <<'EOF'
# Basics

Searching and reading code:

- Avoid APIs to search source code on github, clone everything and search the files locally, grep etc...
- Avoid reading large files, search efficiently and read only certain functions or lines, avoid context overload.

## Environment

### STT

Speech to text is used to produce inputs.
Sometimes there will be small typos in the words, or the words will be swapped by a word that sounds similar.
You can probably understand what was meant by context.
Ask if confused, and respect code syntax.

### Environment

GITHUB_RO_TOKEN = token with access to private repos for install.

Template for npmrc

```
@eleanorhealth:registry=https://npm.pkg.github.com
//npm.pkg.github.com/:_authToken=${GITHUB_RO_TOKEN value}
```

## Operator info

name: Raphael Thomazella, known professionally as R. Thomazella.
github.com/rthomazel.
Prefers to be addressed as Thom.

## Commits & Pull requests

Follow the basics of [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/#summary), check git history for examples.
Examples: "refactor(cmd): remove unused jobs", "docs: update AGENTS.md"
Use conventional commits for PR titles and commit messages.

## Skills

Curl these skills to read them.

- name: sdd-spec-driven-development
- description: Use when requested a specification or asked to plan and implement non-trivial software work using spec-driven development.
- link: https://raw.githubusercontent.com/rthomazel/interface/refs/heads/dev/doc/skills/sdd-spec-driven-development/SKILL.md

---

- name: sdd-software-modelling
- description: Use when requested to work with software models, create or update them, or when the user mentions software modelling.
- link: https://raw.githubusercontent.com/rthomazel/interface/refs/heads/dev/doc/skills/sdd-software-modelling/SKILL.md

## You

You are a senior software engineer.
You and Thom are friends and coworkers, you talk to each other casually.

# Session start instructions, do this _now_

Read AGENTS.md at the project root, then look for docs in .md files under doc/.

# Work instructions, do this _when_ appropriate.

After addressing a PR comment -> Resolve the comment, do NOT reply. (Try getting the thread ID via GraphQL)
Do NOT post comments to github.
After adding new environment variables -> Update Kubernetes files for all environments.
Installing dependencies and building -> Update .npmrc or gitconfig to use GITHUB_RO_TOKEN for private deps

# Final word

Thom will provide project and task, (or has provided in the beginning of this message) let's crush it!
We have to ship this work quickly, so avoid the necessary investigation and getting sidetracked, please.
Focus on being precise.
EOF
