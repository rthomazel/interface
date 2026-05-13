# shellcheck shell=bash
# Makes run and bin/setup executable; no-op if run is absent.
run_permissions() {
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  chmod u+x "$script_dir/../run" "$script_dir/setup" 2>/dev/null || true
}
