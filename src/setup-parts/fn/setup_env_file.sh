# Copies .env-default to .env if missing; sources .env for GITHUB_TOKEN.
setup_env_file() {
	if [[ ! -f "$ENV_FILE" && -f "$SCRIPT_DIR/../.env-default" ]]; then
		cp "$SCRIPT_DIR/../.env-default" "$ENV_FILE"
	fi

	# shellcheck disable=SC1090
	[[ -z "${GITHUB_TOKEN:-}" && -f "$ENV_FILE" ]] && . "$ENV_FILE"
}
