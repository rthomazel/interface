# shellcheck shell=bash
# Makes run and bin/setup executable; no-op if run is absent.
fix_run_permissions() {
	chmod u+x "$SCRIPT_DIR/../run" "$SCRIPT_DIR/setup" 2>/dev/null || true
}
