#!/bin/bash
# Generates Brewfile from the macos column of packages.tsv.
# Run after editing the macos column. The Brewfile is committed so `brew bundle`
# works without a generation step on a fresh Mac.
set -e

HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
MANIFEST="$ROOT/packages.tsv"
OUT="$ROOT/Brewfile"

{
  echo "# GENERATED from packages.tsv by packages/gen-brewfile.sh — DO NOT EDIT."
  echo "# Edit the macos column in packages.tsv, then re-run packages/gen-brewfile.sh."
  echo ""
  awk '
    /^[[:space:]]*#/ || /^[[:space:]]*$/ { next }
    {
      t = $2
      if (t == "-")            next
      if (t ~ /^flatpak:/)     next
      if (t ~ /^aur:/)         next
      if (t ~ /^cask:/)    { sub(/^cask:/, "", t); print "cask \"" t "\""; next }
      if (t ~ /^custom:/)  { print "# WARN: " $1 " uses custom install on macOS — add it manually" > "/dev/stderr"; next }
      print "brew \"" t "\""
    }' "$MANIFEST"
} > "$OUT"

echo "Wrote $OUT"
