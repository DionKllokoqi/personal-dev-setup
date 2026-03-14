#!/usr/bin/env bash
set -euo pipefail

resolve_native_claude() {
  local resolved

  if command -v claude >/dev/null 2>&1; then
    resolved=$(command -v claude)
    if [[ "$resolved" != /mnt/c/* ]]; then
      echo "$resolved"
      return 0
    fi
  fi

  for candidate in "$HOME/.local/bin/claude" "$HOME/.claude/local/claude"; do
    if [[ -x "$candidate" ]]; then
      echo "$candidate"
      return 0
    fi
  done

  return 1
}

warn_if_legacy_npm_install() {
  if ! command -v npm >/dev/null 2>&1; then
    return
  fi

  if npm list -g --depth=0 @anthropic-ai/claude-code >/dev/null 2>&1; then
    echo "Note: Found npm-installed @anthropic-ai/claude-code."
    echo "Native install is now preferred; consider removing the npm package later:"
    echo "  npm uninstall -g @anthropic-ai/claude-code"
  fi
}

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required to install Claude Code." >&2
  exit 1
fi

if existing_claude=$(resolve_native_claude); then
  echo "Claude Code already installed at: $existing_claude"
  "$existing_claude" --version
  warn_if_legacy_npm_install
  exit 0
fi

if command -v claude >/dev/null 2>&1 && [[ "$(command -v claude)" == /mnt/c/* ]]; then
  echo "Found Windows claude in WSL PATH: $(command -v claude)"
  echo "Installing native WSL Claude Code so Windows binaries are not used."
fi

echo "Installing Claude Code via native installer..."
curl -fsSL https://claude.ai/install.sh | bash

hash -r

if ! installed_claude=$(resolve_native_claude); then
  echo "Claude Code installation finished, but native claude was not found on PATH." >&2
  echo "Open a new shell and rerun this script, or check ~/.local/bin and ~/.claude/local." >&2
  exit 1
fi

echo "claude -> $installed_claude"
"$installed_claude" --version

if command -v claude >/dev/null 2>&1 && [[ "$(command -v claude)" == /mnt/c/* ]]; then
  echo "Warning: 'claude' still resolves to Windows path in WSL: $(command -v claude)" >&2
  echo "Put ~/.local/bin earlier in PATH to prioritize native WSL Claude Code." >&2
fi

warn_if_legacy_npm_install

echo "Installed native WSL Claude Code successfully."
