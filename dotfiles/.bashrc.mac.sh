#!/usr/bin/env bash
# shellcheck disable=SC2034 disable=SC1090

# Completions, external scripts, git prompt

# Environment

if [ ! "$(pgrep ssh-agent)" ]; then
  eval "$(ssh-agent)" >/dev/null
elif [[ ! "$SSH_AUTH_SOCK" =~ $(pgrep ssh-agent) ]]; then
  SSH_AUTH_SOCK=$(find /var/folders -name 'agent.*' 2>/dev/null | head -1)
fi

export GOPATH=$HOME/go
export GOBIN=$HOME/go/bin

# todo setup mise shims in path
export PATH="\
$HOME/.local/share/mise/shims:\
$HOME/bin:\
$HOME/.local/bin:\
/opt/homebrew/bin:\
/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin:\
/Applications/Docker.app/Contents/Resources/bin:\
/usr/local/bin:\
/bin:\
/usr/bin:\
/sbin:\
/usr/local/sbin:\
/usr/sbin:\
${GOBIN}"
