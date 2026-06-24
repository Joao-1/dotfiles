#!/bin/bash
# Custom (non-package-manager) installs for Arch. Sourced by install.sh.
# Each function is named install_<name>, matching custom:<name> in packages.tsv.

install_claude() {
  command -v claude &>/dev/null && return
  curl -fsSL https://claude.ai/install.sh | bash
}
