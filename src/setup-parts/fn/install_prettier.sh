# Installs prettier globally if not present.
install_prettier() {
	if ! command -v prettier &>/dev/null; then
		npm install -g prettier 2>/dev/null || echo "npm: prettier install failed" >&2
	fi
}
