#!/usr/bin/env bash
set -euo pipefail

OPENCODE_BIN="$HOME/.opencode/bin/opencode"

if [[ -x "$OPENCODE_BIN" ]]; then
  echo "OpenCode already installed at: $OPENCODE_BIN"
  "$OPENCODE_BIN" --version
  exit 0
fi

if command -v opencode >/dev/null 2>&1; then
  existing=$(command -v opencode)
  if [[ "$existing" == /mnt/c/* ]]; then
    echo "Found Windows opencode in WSL PATH: $existing"
    echo "Installing native WSL OpenCode so Windows binaries are not used."
  else
    echo "OpenCode already installed at: $existing"
    opencode --version
    exit 0
  fi
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required to install OpenCode." >&2
  exit 1
fi

echo "Installing OpenCode via native installer..."
curl -fsSL https://opencode.ai/install | bash

hash -r

if [[ -x "$OPENCODE_BIN" ]]; then
  echo "opencode -> $OPENCODE_BIN"
  "$OPENCODE_BIN" --version
elif command -v opencode >/dev/null 2>&1; then
  echo "opencode -> $(command -v opencode)"
  opencode --version
else
  echo "OpenCode installation finished, but opencode was not found on PATH." >&2
  echo "Open a new shell and rerun this script, or check ~/.opencode/bin." >&2
  exit 1
fi

echo "Installed native WSL OpenCode successfully."
