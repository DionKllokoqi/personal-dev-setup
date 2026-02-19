#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update

# Core shell/tools
sudo apt-get install -y \
  zsh \
  git \
  tmux \
  curl \
  wget \
  unzip \
  build-essential \
  ca-certificates \
  gnupg \
  lsb-release \
  fzf \
  eza \
  autojump \
  python3 \
  python3-pip \
  python3-venv

# Optional CLI tools (install if available via apt)
for pkg in azure-cli gh awscli kubectl pre-commit; do
  if apt-cache show "$pkg" >/dev/null 2>&1; then
    sudo apt-get install -y "$pkg"
  else
    echo "Skipping $pkg (not in apt)."
  fi
done

echo "WSL bootstrap complete. Some tools require manual install (see docs/setup-checklist.md)."
