#!/bin/bash
# Custom (non-apt) installs for Ubuntu. Sourced by install.sh.
# Each function is named install_<name>, matching custom:<name> in packages.tsv.

install_mise() {
  command -v mise &>/dev/null && return
  curl -fsSL https://mise.run | sh
}

install_kubectl() {
  command -v kubectl &>/dev/null && return
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key \
    | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" \
    | sudo tee /etc/apt/sources.list.d/kubernetes.list >/dev/null
  sudo apt-get update && sudo apt-get install -y kubectl
}

install_k9s() {
  command -v k9s &>/dev/null && return
  local arch tmp
  arch="$(dpkg --print-architecture)"
  tmp="$(mktemp --suffix=.deb)"
  curl -fsSL "https://github.com/derailed/k9s/releases/latest/download/k9s_linux_${arch}.deb" -o "$tmp"
  sudo apt-get install -y "$tmp"
  rm -f "$tmp"
}

install_yq() {
  command -v yq &>/dev/null && return   # apt 'yq' is a different tool; use the mikefarah binary
  local arch
  arch="$(dpkg --print-architecture)"
  sudo curl -fsSL "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${arch}" -o /usr/local/bin/yq
  sudo chmod +x /usr/local/bin/yq
}

install_awscli() {
  command -v aws &>/dev/null && return   # apt ships v1; install v2
  local tmp
  tmp="$(mktemp -d)"
  curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -o "$tmp/awscliv2.zip"
  ( cd "$tmp" && unzip -q awscliv2.zip && sudo ./aws/install --update )
  rm -rf "$tmp"
}

install_azurecli() {
  command -v az &>/dev/null && return
  curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
}

install_gcloud() {
  command -v gcloud &>/dev/null && return
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg \
    | sudo gpg --dearmor -o /etc/apt/keyrings/cloud.google.gpg
  echo "deb [signed-by=/etc/apt/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" \
    | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list >/dev/null
  sudo apt-get update && sudo apt-get install -y google-cloud-cli
}

install_clickup() {
  command -v clickup &>/dev/null && return
  echo "    ClickUp has no apt/flatpak package — download .deb from https://clickup.com/download"
}

install_claude() {
  command -v claude &>/dev/null && return
  curl -fsSL https://claude.ai/install.sh | bash
}
