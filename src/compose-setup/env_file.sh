# shellcheck shell=bash
# Copies .env-default to .env if missing
env_file() {
  local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local ENV_FILE="$script_dir/../.env"
  if [[ ! -f "$ENV_FILE" && -f "$SCRIPT_DIR/../.env-default" ]]; then
    cp "$SCRIPT_DIR/../.env-default" "$ENV_FILE"
  fi
}
