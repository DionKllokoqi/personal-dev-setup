#!/usr/bin/env bash
set -euo pipefail

TMP_DIR=$(mktemp -d)
cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

ZIP_PATH="$TMP_DIR/awscliv2.zip"
EXTRACT_DIR="$TMP_DIR/aws"

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "$ZIP_PATH"
unzip -q "$ZIP_PATH" -d "$TMP_DIR"

if command -v aws >/dev/null 2>&1; then
  sudo "$EXTRACT_DIR/install" --update
else
  sudo "$EXTRACT_DIR/install"
fi

aws --version
