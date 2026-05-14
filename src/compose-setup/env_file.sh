# shellcheck shell=bash
# Copies .env-default to .env if missing
env_file() {
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local ENV_FILE="$script_dir/../.env"
  if [[ ! -f "$ENV_FILE" && -f "$script_dir/../.env-default" ]]; then
    cp "$script_dir/../.env-default" "$ENV_FILE"
  fi
}
