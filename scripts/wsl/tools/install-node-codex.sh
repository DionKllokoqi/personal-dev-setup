#!/usr/bin/env bash
set -euo pipefail

NVM_VERSION="v0.40.3"
NODE_TARGET="${NODE_TARGET:-lts/*}"
NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

install_nvm() {
  if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    echo "nvm already installed at $NVM_DIR"
    return
  fi

  if ! command -v curl >/dev/null 2>&1; then
    echo "curl is required to install nvm." >&2
    exit 1
  fi

  echo "Installing nvm ($NVM_VERSION)..."
  curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" | bash
}

load_nvm() {
  export NVM_DIR
  if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
    echo "nvm not found at $NVM_DIR/nvm.sh after installation." >&2
    exit 1
  fi

  # shellcheck source=/dev/null
  . "$NVM_DIR/nvm.sh"
}

install_node() {
  echo "Installing Node.js target: $NODE_TARGET"
  nvm install "$NODE_TARGET"
  nvm alias default "$NODE_TARGET" >/dev/null
  nvm use --silent default >/dev/null
}

install_codex() {
  if npm list -g --depth=0 @openai/codex >/dev/null 2>&1; then
    echo "codex already installed globally for current Node version"
    return
  fi

  echo "Installing @openai/codex globally..."
  npm install -g @openai/codex
}

assert_not_windows_path() {
  local cmd="$1"
  local resolved
  resolved=$(command -v "$cmd" || true)

  if [[ -z "$resolved" ]]; then
    echo "Expected command not found: $cmd" >&2
    exit 1
  fi

  if [[ "$resolved" == /mnt/c/* ]]; then
    echo "$cmd resolved to a Windows path ($resolved). Fix PATH ordering in WSL." >&2
    exit 1
  fi

  echo "$cmd -> $resolved"
}

install_nvm
load_nvm
install_node
install_codex

assert_not_windows_path node
assert_not_windows_path npm
assert_not_windows_path codex

echo "Installed native WSL Node.js + codex successfully."
