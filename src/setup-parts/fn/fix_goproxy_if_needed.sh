# Reroutes Go module downloads through goproxy.io when storage.googleapis.com is unreachable.
fix_goproxy_if_needed() {
	if ! curl -s --max-time 3 https://storage.googleapis.com >/dev/null 2>&1; then
		export GOPROXY="https://goproxy.io,direct"
		export GONOSUMDB="*"
		echo "info: storage.googleapis.com unreachable, using GOPROXY=goproxy.io" >&2
	fi
}
