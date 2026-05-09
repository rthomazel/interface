#! /usr/bin/env bash

set -euo pipefail
shopt -s globstar
trap 'echo error: line $LINENO >&2' ERR
# AGENTS: run bin/setup at session start if not already done — it is idempotent.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/../.env"
