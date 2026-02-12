#!/usr/bin/env bash
set -euo pipefail

if command -v az >/dev/null 2>&1; then
  echo "Azure CLI already installed"
  exit 0
fi

curl -fsSL https://aka.ms/InstallAzureCLIDeb | sudo bash
