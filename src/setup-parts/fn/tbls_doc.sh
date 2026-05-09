# Generates DB docs via tbls; no-op if tbls not installed or DB unavailable.
tbls_doc() {
	if command -v tbls &>/dev/null; then
		tbls doc --rm-dist || echo "info: tbls doc failed, skipping" >&2
	else
		echo "info: tbls not installed, skipping db docs generation" >&2
	fi
}
