# shellcheck shell=bash
# Writes .npmrc and configures git for Eleanor Health Node projects, then installs packages. Detects yarn or npm.
eleanor_node_download() {
  local ENV_FILE="$SCRIPT_DIR/../.env"
  # shellcheck disable=SC1090
  [[ -z "${GITHUB_TOKEN:-}" && -f "$ENV_FILE" ]] && . "$ENV_FILE"

  if [[ -z "${GITHUB_TOKEN:-}" ]]; then
    echo "info: GITHUB_TOKEN not set, skipping Eleanor Health Node auth" >&2
    echo "info: for private @eleanorhealth packages, configure .npmrc manually:" >&2
    echo "  @eleanorhealth:registry=https://npm.pkg.github.com" >&2
    echo "  //npm.pkg.github.com/:_authToken=<your-token>" >&2
  else
    token_count=$(grep -c '^GITHUB_TOKEN=' "$ENV_FILE" || true)
    if [[ "$token_count" -gt 1 ]]; then
      echo "error: multiple GITHUB_TOKEN entries in .env, expected exactly one" >&2
      return 1
    fi

    if ! grep -q '^GITHUB_TOKEN=.' "$ENV_FILE"; then
      sed -i "s|^GITHUB_TOKEN=$|GITHUB_TOKEN=${GITHUB_TOKEN}|" "$ENV_FILE"
    fi

    cat >"$SCRIPT_DIR/../.npmrc" <<NPMRC
@eleanorhealth:registry = https://npm.pkg.github.com
//npm.pkg.github.com/:_authToken = ${GITHUB_TOKEN}

engine-strict = true
NPMRC

    git config --global url."https://x-access-token:${GITHUB_TOKEN}@github.com/eleanorhealth".insteadOf "https://github.com/eleanorhealth"
  fi

  if [[ -f "$SCRIPT_DIR/../yarn.lock" ]]; then
    yarn install
  else
    npm install
  fi
}
