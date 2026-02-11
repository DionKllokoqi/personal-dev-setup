#!/usr/bin/env bash
set -euo pipefail

if command -v tofu >/dev/null 2>&1; then
  echo "OpenTofu already installed"
  exit 0
fi

curl -fsSL https://get.opentofu.org/install-opentofu.sh | bash -s -- --install-method deb
