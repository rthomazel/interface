# Imports GPG key and configures git signing; skips if no key.
setup_gpg_signing() {
	if [[ -z "${GPG_PRIVATE_KEY:-}" ]]; then
		echo "bin/setup: GPG_PRIVATE_KEY not set, skipping" >&2
		return 0
	fi

	mkdir -p ~/.gnupg && chmod 700 ~/.gnupg
	echo "allow-loopback-pinentry" >~/.gnupg/gpg-agent.conf
	gpg-connect-agent reloadagent /bye >/dev/null 2>&1 || true

	if [[ -n "${GPG_PASSPHRASE:-}" ]]; then
		echo "${GPG_PRIVATE_KEY}" | base64 --decode |
			gpg --batch --passphrase "${GPG_PASSPHRASE}" --pinentry-mode loopback --import
	else
		echo "${GPG_PRIVATE_KEY}" | base64 --decode | gpg --batch --import
	fi

	FINGERPRINT=$(gpg --list-secret-keys --with-colons |
		awk -F: '/^fpr:/{print $10; exit}')

	git config --global user.signingkey "${FINGERPRINT}"
	git config --global commit.gpgsign true
	git config --global gpg.format openpgp
	git config --global gpg.program gpg

	if [[ -n "${GPG_PASSPHRASE:-}" ]]; then
		cat >/usr/local/bin/gpg-passphrase-wrapper <<'WRAPPER'
#!/usr/bin/env bash
exec gpg --batch --passphrase "${GPG_PASSPHRASE}" --pinentry-mode loopback "$@"
WRAPPER
		chmod +x /usr/local/bin/gpg-passphrase-wrapper
		git config --global gpg.program /usr/local/bin/gpg-passphrase-wrapper
	fi

	echo "bin/setup: GPG signing configured (${FINGERPRINT})" >&2
}
