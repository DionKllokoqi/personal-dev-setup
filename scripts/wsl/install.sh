#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/../.." && pwd)
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

mkdir -p "$BACKUP_DIR"

link_file() {
  local src="$1"
  local dest="$2"

  if [[ -e "$dest" && ! -L "$dest" ]]; then
    mv "$dest" "$BACKUP_DIR/"
  fi

  ln -sf "$src" "$dest"
}

link_file "$REPO_ROOT/dotfiles/wsl/.zshrc" "$HOME/.zshrc"
link_file "$REPO_ROOT/dotfiles/wsl/.p10k.zsh" "$HOME/.p10k.zsh"
link_file "$REPO_ROOT/dotfiles/wsl/.tmux.conf" "$HOME/.tmux.conf"

if [[ ! -f "$HOME/.gitconfig" ]]; then
  cp "$REPO_ROOT/dotfiles/wsl/gitconfig.wsl" "$HOME/.gitconfig"
  echo "Created ~/.gitconfig from template. Remember to update name/email placeholders."
fi

if [[ ! -f "$HOME/.gitignore_global" ]]; then
  cp "$REPO_ROOT/dotfiles/shared/gitignore_global" "$HOME/.gitignore_global"
fi

echo "Done. Backup (if any) at: $BACKUP_DIR"
