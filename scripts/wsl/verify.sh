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

check_not_windows_path() {
  local cmd="$1"
  local resolved
  resolved=$(command -v "$cmd")
  if [[ "$resolved" == /mnt/c/* ]]; then
    fail "$cmd resolves to Windows path in WSL: $resolved"
  fi
}

check_nvm_managed_path() {
  local cmd="$1"
  local resolved
  resolved=$(readlink -f "$(command -v "$cmd")")
  if [[ "$resolved" != "$HOME/.nvm/"* ]]; then
    fail "$cmd is not nvm-managed in WSL: $resolved"
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

check_line_in_file() {
  local path="$1"
  local expected="$2"
  if ! grep -Fqx "$expected" "$path"; then
    fail "$path is missing expected line: $expected"
  fi
}

check_codex_config() {
  local path="$HOME/.codex/config.toml"

  [[ -f "$path" ]] || fail "$path is missing"

  check_line_in_file "$path" 'personality = "pragmatic"'
  check_line_in_file "$path" 'model = "gpt-5.3-codex"'
  check_line_in_file "$path" 'model_reasoning_effort = "high"'
  check_line_in_file "$path" 'shell_snapshot = true'
  check_line_in_file "$path" 'approval_policy = "on-request"'
  check_line_in_file "$path" 'sandbox_mode = "workspace-write"'
  check_line_in_file "$path" "[projects.\"$HOME/projects\"]"
  check_line_in_file "$path" 'trust_level = "trusted"'
  check_line_in_file "$path" "[projects.\"$HOME\"]"
  check_line_in_file "$path" 'trust_level = "untrusted"'
}

echo "Verifying WSL dotfiles and tools..."

check_link_target "$HOME/.zshrc" "$REPO_ROOT/dotfiles/wsl/.zshrc"
check_link_target "$HOME/.p10k.zsh" "$REPO_ROOT/dotfiles/wsl/.p10k.zsh"
check_link_target "$HOME/.tmux.conf" "$REPO_ROOT/dotfiles/wsl/.tmux.conf"
check_codex_config

[[ -f "$HOME/.gitconfig" ]] || fail "~/.gitconfig is missing"
[[ -f "$HOME/.gitignore_global" ]] || fail "~/.gitignore_global is missing"

check_cmd zsh
check_cmd git
check_cmd tmux
check_cmd python3
check_cmd pip3
check_cmd xdg-open
check_cmd wslview

echo "Checking optional tools (informational)..."
for opt in az azd gh tofu rustc pyenv aws kubectl pre-commit; do
  if command -v "$opt" >/dev/null 2>&1; then
    echo "OK(optional): $opt"
  else
    echo "MISSING(optional): $opt"
  fi
done

if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
  echo "OK(optional): nvm"
else
  echo "MISSING(optional): nvm"
fi

for opt in node npm codex; do
  if command -v "$opt" >/dev/null 2>&1; then
    check_not_windows_path "$opt"
    check_nvm_managed_path "$opt"
    echo "OK(optional): $opt (nvm-managed)"
  else
    echo "MISSING(optional): $opt"
  fi
done

echo "PASS: WSL verification completed"
