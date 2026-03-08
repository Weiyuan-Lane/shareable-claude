#!/usr/bin/env bash
set -euo pipefail

if command -v jq &>/dev/null; then
  echo "jq is already installed: $(jq --version)"
  exit 0
fi

echo "Installing jq..."

case "$(uname -s)" in
  Darwin)
    if command -v brew &>/dev/null; then
      brew install jq
    elif command -v port &>/dev/null; then
      sudo port install jq
    else
      echo "Error: Homebrew or MacPorts required on macOS. Install from https://brew.sh" >&2
      exit 1
    fi
    ;;
  Linux)
    if command -v apt-get &>/dev/null; then
      sudo apt-get install -y jq
    elif command -v dnf &>/dev/null; then
      sudo dnf install -y jq
    elif command -v yum &>/dev/null; then
      sudo yum install -y jq
    elif command -v apk &>/dev/null; then
      sudo apk add jq
    elif command -v pacman &>/dev/null; then
      sudo pacman -S --noconfirm jq
    else
      echo "Error: No supported package manager found. Install jq manually from https://jqlang.org/download/" >&2
      exit 1
    fi
    ;;
  *)
    echo "Error: Unsupported OS '$(uname -s)'. Install jq manually from https://jqlang.org/download/" >&2
    exit 1
    ;;
esac

echo "jq installed: $(jq --version)"
