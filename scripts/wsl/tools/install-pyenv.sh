#!/usr/bin/env bash
set -euo pipefail

if command -v pyenv >/dev/null 2>&1; then
  echo "pyenv already installed"
  exit 0
fi

if [[ -d "$HOME/.pyenv" ]]; then
  echo "Found $HOME/.pyenv but pyenv is not on PATH."
  echo "Add PYENV_ROOT and PATH to your shell config, then restart your shell."
  exit 0
fi

sudo apt-get update
sudo apt-get install -y \
  make build-essential libssl-dev zlib1g-dev \
  libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
  libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
  libffi-dev liblzma-dev

git clone https://github.com/pyenv/pyenv.git "$HOME/.pyenv"

cat <<'SNIPPET'
Add to your shell config:

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi
SNIPPET
