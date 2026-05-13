# shellcheck shell=bash
# Detects yarn or npm from lockfile and runs the appropriate install command.
js_install() {
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  if [[ -f "$script_dir/../yarn.lock" ]]; then
    yarn install
  else
    npm install
  fi
}
