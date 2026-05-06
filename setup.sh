#!/bin/bash
# setup.sh — Run this on a fresh Mac to replicate the full environment.
# Usage: bash setup.sh

set -e

echo "==> Installing Homebrew..."
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Add Homebrew to PATH (Apple Silicon Macs)
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "    Homebrew already installed, skipping."
fi

echo "==> Installing packages from Brewfile..."
brew bundle --file="$(dirname "$0")/Brewfile"

echo "==> Setting up git config..."
bash "$(dirname "$0")/scripts/setup-ssh.sh"

echo "==> Linking zsh config..."
ln -sf "$(dirname "$0")/zsh/.zshrc" ~/.zshrc

echo ""
echo "Done! Open a new terminal for all changes to take effect."
