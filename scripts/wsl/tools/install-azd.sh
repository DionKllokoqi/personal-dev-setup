#!/usr/bin/env bash
set -euo pipefail

if command -v azd >/dev/null 2>&1; then
  echo "Azure Developer CLI already installed"
  exit 0
fi

curl -fsSL https://aka.ms/install-azd.sh | bash
