# shellcheck shell=bash
# Detects yarn or npm from lockfile and runs the appropriate install command.
js_install() {
  if [[ -f "$SCRIPT_DIR/../yarn.lock" ]]; then
    yarn install
  else
    npm install
  fi
}
