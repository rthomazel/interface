# Generates DB docs via tbls; tries localhost then 10.0.2.2 as fallback. Silent no-op if unavailable.
tbls_doc() {
	if ! command -v tbls &>/dev/null; then
		return 0
	fi

	local config_file
	config_file=$(ls .tbls.yml tbls.yml 2>/dev/null | head -1)
	[[ -z "$config_file" ]] && return 0

	if tbls doc --rm-dist 2>/dev/null; then
		return 0
	fi

	local tmp
	tmp=$(mktemp /tmp/tbls-XXXXXX.yml)
	# 10.0.2.2 is the host address when the agent runs in rootless Docker
	sed 's|localhost|10.0.2.2|g' "$config_file" >"$tmp"
	tbls doc --rm-dist --config "$tmp" 2>/dev/null || true
	rm -f "$tmp"
}
