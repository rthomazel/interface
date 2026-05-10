# shellcheck shell=bash
# Reroutes Go modules through goproxy.io if needed, then runs go mod download and go install tool.
go_download() {
  if ! curl -s --max-time 3 https://storage.googleapis.com >/dev/null 2>&1; then
    export GOPROXY="https://goproxy.io,direct"
    export GONOSUMDB="*"
    echo "info: storage.googleapis.com unreachable, using GOPROXY=goproxy.io" >&2
  fi
  go mod download
  go install tool 2>/dev/null || true
}
