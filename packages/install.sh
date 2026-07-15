#!/bin/bash
# Generic package installer driven by ../packages.tsv.
# Usage: install.sh <macos|arch|ubuntu>
#
# Reads the column for the target OS, groups tokens by install method,
# and installs each group in one batch. Non-trivial installs (custom:NAME)
# are delegated to install_NAME functions in packages/custom-<os>.sh.
set -e

OS="$1"
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
MANIFEST="$ROOT/packages.tsv"

case "$OS" in
  macos)  COL=2 ;;
  arch)   COL=3 ;;
  ubuntu) COL=4 ;;
  *) echo "usage: install.sh <macos|arch|ubuntu>" >&2; exit 1 ;;
esac

# --- Read the target column, dropping comments, blanks, and skips ('-') ---
# while-read loop (not mapfile) so this also runs on macOS's bash 3.2.
native=(); cask=(); aur=(); flat=(); custom=()
while IFS= read -r tok; do
  case "$tok" in
    cask:*)    cask+=("${tok#cask:}") ;;
    aur:*)     aur+=("${tok#aur:}") ;;
    flatpak:*) flat+=("${tok#flatpak:}") ;;
    custom:*)  custom+=("${tok#custom:}") ;;
    *)         native+=("$tok") ;;
  esac
done < <(awk -v c="$COL" '
  /^[[:space:]]*#/ || /^[[:space:]]*$/ { next }
  $c != "-" { print $c }' "$MANIFEST")

run_custom() {
  [[ ${#custom[@]} -eq 0 ]] && return
  source "$HERE/custom-$OS.sh"
  for name in "${custom[@]}"; do
    echo "==> Custom install: $name"
    "install_$name"
  done
}

flatpak_apps() {
  [[ ${#flat[@]} -eq 0 ]] && return
  echo "==> Configuring Flathub (user)..."
  flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  # Only install apps not already present — flatpak install re-runs otherwise.
  local todo=()
  for app in "${flat[@]}"; do
    if flatpak info "$app" &>/dev/null; then
      echo "    $app already installed, skipping."
    else
      todo+=("$app")
    fi
  done
  [[ ${#todo[@]} -eq 0 ]] && return
  echo "==> Installing GUI apps (flatpak)..."
  flatpak --user install -y --noninteractive flathub "${todo[@]}"
}

case "$OS" in
  macos)
    echo "==> Regenerating Brewfile from manifest..."
    bash "$HERE/gen-brewfile.sh"
    echo "==> Installing Homebrew..."
    if ! command -v brew &>/dev/null; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    echo "==> brew bundle..."
    brew bundle --file="$ROOT/Brewfile"
    ;;

  arch)
    echo "==> Updating system..."
    sudo pacman -Syu --noconfirm
    echo "==> Installing CLI tools (pacman)..."
    sudo pacman -S --needed --noconfirm base-devel "${native[@]}"
    if [[ ${#aur[@]} -gt 0 ]]; then
      if ! command -v yay &>/dev/null; then
        echo "==> Bootstrapping yay (AUR helper)..."
        tmp="$(mktemp -d)"
        git clone https://aur.archlinux.org/yay.git "$tmp/yay"
        ( cd "$tmp/yay" && makepkg -si --noconfirm )
        rm -rf "$tmp"
      fi
      echo "==> Installing AUR packages (yay)..."
      yay -S --needed --noconfirm "${aur[@]}"
    fi
    flatpak_apps
    run_custom
    ;;

  ubuntu)
    echo "==> Updating apt..."
    sudo apt-get update
    echo "==> Installing build/bootstrap deps..."
    sudo apt-get install -y curl wget unzip gnupg ca-certificates
    echo "==> Installing CLI tools (apt)..."
    sudo apt-get install -y "${native[@]}"
    flatpak_apps
    run_custom
    ;;
esac

echo ""
echo "Done installing packages for $OS."
