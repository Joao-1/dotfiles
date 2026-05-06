#!/bin/bash
# Copies .gitconfig from dotfiles to ~/.gitconfig replacing the signing key placeholder.
# Run this once on each new machine after cloning dotfiles.

DOTFILES_DIR="$(dirname "$0")/.."

echo "Enter your SSH signing public key (ssh-ed25519 ...):"
read -r SIGNING_KEY

if [[ -z "$SIGNING_KEY" ]]; then
  echo "Error: no key provided." >&2
  exit 1
fi

TMPFILE=$(mktemp)
sed "s|SIGNING_KEY_PLACEHOLDER|$SIGNING_KEY|" \
  "$DOTFILES_DIR/git/.gitconfig" > "$TMPFILE"
mv "$TMPFILE" ~/.gitconfig

echo "==> Creating ~/.ssh/allowed_signers..."
mkdir -p ~/.ssh
echo "fukurouroy@pm.me $SIGNING_KEY" > ~/.ssh/allowed_signers

echo "Done. ~/.gitconfig and ~/.ssh/allowed_signers configured."
