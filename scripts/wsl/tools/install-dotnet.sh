#!/usr/bin/env bash
set -euo pipefail

if command -v dotnet >/dev/null 2>&1; then
  current_version=$(dotnet --version 2>/dev/null || true)
  if [[ -n "$current_version" ]]; then
    echo "dotnet already installed ($current_version)"
    exit 0
  fi
fi

sudo apt-get update

if [[ ! -f /etc/apt/sources.list.d/microsoft-prod.list ]]; then
  wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb" -O /tmp/packages-microsoft-prod.deb
  sudo dpkg -i /tmp/packages-microsoft-prod.deb
  rm -f /tmp/packages-microsoft-prod.deb
  sudo apt-get update
fi

latest_dotnet_pkg=$(
  apt-cache search '^dotnet-sdk-[0-9]+\.[0-9]+$' \
    | awk '{print $1}' \
    | sort -V \
    | tail -n1
)

if [[ -z "$latest_dotnet_pkg" ]]; then
  echo "No dotnet-sdk-* package found in apt sources."
  exit 1
fi

sudo apt-get install -y "$latest_dotnet_pkg"

echo "Installed .NET SDK package: $latest_dotnet_pkg"
