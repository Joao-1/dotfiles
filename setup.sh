#!/bin/bash
# setup.sh — Replicate the full environment on a fresh machine.
# Supports macOS, Arch Linux, and Ubuntu.
# Usage: bash setup.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

detect_os() {
  if [[ "$(uname -s)" == "Darwin" ]]; then
    echo "macos"
  elif [[ -f /etc/arch-release ]]; then
    echo "arch"
  elif grep -qi ubuntu /etc/os-release 2>/dev/null; then
    echo "ubuntu"
  else
    echo "unknown"
  fi
}

OS="$(detect_os)"
echo "==> Detected OS: $OS"

if [[ "$OS" == "unknown" ]]; then
  echo "Unsupported OS. Supported: macOS, Arch Linux, Ubuntu." >&2
  exit 1
fi

echo "==> Installing packages..."
bash "$DOTFILES_DIR/packages/install.sh" "$OS"

echo "==> Setting up git config..."
bash "$DOTFILES_DIR/scripts/setup-ssh.sh"

echo "==> Installing Powerlevel10k theme..."
P10K_DIR="$HOME/.local/share/powerlevel10k"
if [[ -d "$P10K_DIR/.git" ]]; then
  git -C "$P10K_DIR" pull --quiet
else
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi

echo "==> Linking zsh config..."
ln -sf "$DOTFILES_DIR/zsh/.zshrc" ~/.zshrc
ln -sf "$DOTFILES_DIR/.p10k.zsh" ~/.p10k.zsh

echo "==> Setting zsh as default shell..."
ZSH_BIN="$(command -v zsh)"
if [[ -n "$ZSH_BIN" && "$SHELL" != "$ZSH_BIN" ]]; then
  grep -qxF "$ZSH_BIN" /etc/shells || echo "$ZSH_BIN" | sudo tee -a /etc/shells >/dev/null
  chsh -s "$ZSH_BIN"
fi

echo ""
echo "Done! Open a new terminal for all changes to take effect."
