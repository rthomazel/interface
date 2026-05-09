# Exports GOPRIVATE for Eleanor Health private Go modules.
setup_goprivate() {
	export GOPRIVATE="github.com/eleanorhealth/*"
	[[ -n "${CLAUDE_ENV_FILE:-}" ]] && echo "GOPRIVATE=github.com/eleanorhealth/*" >>"$CLAUDE_ENV_FILE"
}
