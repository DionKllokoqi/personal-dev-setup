#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/../.." && pwd)

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

check_cmd() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    fail "Missing command: $cmd"
  fi
}

check_link_target() {
  local path="$1"
  local expected="$2"
  if [[ ! -L "$path" ]]; then
    fail "$path is not a symlink"
  fi
  local actual
  actual=$(readlink -f "$path")
  local expected_abs
  expected_abs=$(readlink -f "$expected")
  if [[ "$actual" != "$expected_abs" ]]; then
    fail "$path points to $actual, expected $expected_abs"
  fi
}

echo "Verifying WSL dotfiles and tools..."

check_link_target "$HOME/.zshrc" "$REPO_ROOT/dotfiles/wsl/.zshrc"
check_link_target "$HOME/.p10k.zsh" "$REPO_ROOT/dotfiles/wsl/.p10k.zsh"

[[ -f "$HOME/.gitconfig" ]] || fail "~/.gitconfig is missing"
[[ -f "$HOME/.gitignore_global" ]] || fail "~/.gitignore_global is missing"

check_cmd zsh
check_cmd git
check_cmd tmux
check_cmd gh
check_cmd python3
check_cmd pip3

echo "Checking optional tools (informational)..."
for opt in az azd tofu rustc pyenv aws kubectl pre-commit codex; do
  if command -v "$opt" >/dev/null 2>&1; then
    echo "OK(optional): $opt"
  else
    echo "MISSING(optional): $opt"
  fi
done

echo "PASS: WSL verification completed"
