# Configures GOPRIVATE and git HTTPS auth for Eleanor Health Go projects. Humans should use SSH instead.
setup_eleanor_go_auth() {
	# shellcheck disable=SC1090
	[[ -z "${GITHUB_TOKEN:-}" && -f "$ENV_FILE" ]] && . "$ENV_FILE"

	export GOPRIVATE="github.com/eleanorhealth/*"
	[[ -n "${CLAUDE_ENV_FILE:-}" ]] && echo "GOPRIVATE=github.com/eleanorhealth/*" >>"$CLAUDE_ENV_FILE"

	# Humans: do not set GITHUB_TOKEN; configure SSH access instead.
	if [[ -z "${GITHUB_TOKEN:-}" ]]; then
		echo "info: GITHUB_TOKEN not set, skipping Eleanor Health Go auth" >&2
		echo "info: for private module access, configure SSH:" >&2
		echo "  git config --global url.\"ssh://git@github.com/\".insteadOf \"https://github.com/\"" >&2
		return 0
	fi

	token_count=$(grep -c '^GITHUB_TOKEN=' "$ENV_FILE" || true)
	if [[ "$token_count" -gt 1 ]]; then
		echo "error: multiple GITHUB_TOKEN entries in .env, expected exactly one" >&2
		return 1
	fi

	if ! grep -q '^GITHUB_TOKEN=.' "$ENV_FILE"; then
		sed -i "s|^GITHUB_TOKEN=$|GITHUB_TOKEN=${GITHUB_TOKEN}|" "$ENV_FILE"
	fi

	git config --global url."https://x-access-token:${GITHUB_TOKEN}@github.com/eleanorhealth".insteadOf "https://github.com/eleanorhealth"
}
