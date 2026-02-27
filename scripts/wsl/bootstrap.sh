#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update

# Install latest Git from the official Git maintainers PPA.
# `software-properties-common` provides `apt-add-repository`.
sudo apt-get install -y software-properties-common
sudo apt-add-repository -y ppa:git-core/ppa
sudo apt-get update

# Core shell/tools
sudo apt-get install -y \
  zsh \
  git \
  tmux \
  htop \
  xdg-utils \
  wslu \
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
for pkg in azure-cli gh kubectl pre-commit; do
  if apt-cache show "$pkg" >/dev/null 2>&1; then
    sudo apt-get install -y "$pkg"
  else
    echo "Skipping $pkg (not in apt)."
  fi
done

echo "WSL bootstrap complete. Some tools require manual install (see docs/setup-checklist.md)."
