# Copies .env-default to .env if missing
setup_env_file() {
	if [[ ! -f "$ENV_FILE" && -f "$SCRIPT_DIR/../.env-default" ]]; then
		cp "$SCRIPT_DIR/../.env-default" "$ENV_FILE"
	fi
}
