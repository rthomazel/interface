# shellcheck shell=bash
# Installs mise if missing, runs mise install, activates shims in PATH. Always call first.
toolchain() {
	if ! command -v mise &>/dev/null; then
		curl https://mise.run | sh
		export PATH="$HOME/.local/bin:$PATH"
	fi
	mise install
	export PATH="$HOME/.local/share/mise/shims:$PATH"
}
