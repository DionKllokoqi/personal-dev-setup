#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/../.." && pwd)
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

mkdir -p "$BACKUP_DIR"

warn() {
  echo "Warning: $1" >&2
}

install_oh_my_zsh() {
  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    echo "Oh My Zsh already installed"
    return
  fi

  if ! command -v curl >/dev/null 2>&1; then
    warn "Skipping Oh My Zsh install because curl is missing."
    return
  fi

  echo "Installing Oh My Zsh..."
  if ! RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; then
    warn "Oh My Zsh installation failed. Re-run manually if needed."
  fi
}

install_oh_my_zsh_customizations() {
  local zsh_dir="$HOME/.oh-my-zsh"
  local zsh_custom="${ZSH_CUSTOM:-$zsh_dir/custom}"

  if [[ ! -d "$zsh_dir" ]]; then
    echo "Skipping Oh My Zsh customizations (Oh My Zsh is not installed)"
    return
  fi

  if ! command -v git >/dev/null 2>&1; then
    warn "Skipping Oh My Zsh customizations because git is missing."
    return
  fi

  mkdir -p "$zsh_custom/plugins" "$zsh_custom/themes"

  clone_repo_if_missing() {
    local repo="$1"
    local dest="$2"
    local label="$3"
    if [[ -d "$dest" ]]; then
      echo "$label already installed"
      return
    fi
    echo "Installing $label..."
    if ! git clone "$repo" "$dest"; then
      warn "Failed to install $label from $repo"
    fi
  }

  clone_repo_if_missing https://github.com/romkatv/powerlevel10k.git \
    "$zsh_custom/themes/powerlevel10k" \
    "powerlevel10k theme"
  clone_repo_if_missing https://github.com/zsh-users/zsh-autosuggestions.git \
    "$zsh_custom/plugins/zsh-autosuggestions" \
    "zsh-autosuggestions plugin"
  clone_repo_if_missing https://github.com/marlonrichert/zsh-autocomplete.git \
    "$zsh_custom/plugins/zsh-autocomplete" \
    "zsh-autocomplete plugin"
  clone_repo_if_missing https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
    "$zsh_custom/plugins/fast-syntax-highlighting" \
    "fast-syntax-highlighting plugin"
}

install_pyenv_virtualenv_plugin() {
  local pyenv_root="${PYENV_ROOT:-$HOME/.pyenv}"
  local plugin_dir="$pyenv_root/plugins/pyenv-virtualenv"

  if [[ ! -d "$pyenv_root" ]]; then
    echo "Skipping pyenv-virtualenv plugin install (pyenv not found at $pyenv_root)"
    return
  fi

  if [[ -d "$plugin_dir" ]]; then
    echo "pyenv-virtualenv plugin already installed"
    return
  fi

  if ! command -v git >/dev/null 2>&1; then
    warn "Skipping pyenv-virtualenv plugin install because git is missing."
    return
  fi

  echo "Installing pyenv-virtualenv plugin..."
  if ! git clone https://github.com/pyenv/pyenv-virtualenv.git "$plugin_dir"; then
    warn "pyenv-virtualenv plugin installation failed. Re-run manually if needed."
  fi
}

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

install_oh_my_zsh
install_oh_my_zsh_customizations
install_pyenv_virtualenv_plugin

if [[ ! -f "$HOME/.gitconfig" ]]; then
  cp "$REPO_ROOT/dotfiles/wsl/gitconfig.wsl" "$HOME/.gitconfig"
  echo "Created ~/.gitconfig from template. Remember to update name/email placeholders."
fi

if [[ ! -f "$HOME/.gitignore_global" ]]; then
  cp "$REPO_ROOT/dotfiles/shared/gitignore_global" "$HOME/.gitignore_global"
fi

echo "Done. Backup (if any) at: $BACKUP_DIR"
