# Runs go mod download and go install tool.
go_download() {
	go mod download
	go install tool 2>/dev/null || true
}
