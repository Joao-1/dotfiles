# Setup Guide

Supports **macOS**, **Arch Linux**, and **Ubuntu**.

## Fresh install

```bash
git clone https://github.com/joaovitor/dotfiles ~/dotfiles
cd ~/dotfiles
bash setup.sh
source ~/.zshrc
```

---

## What setup.sh does

1. Detects the OS (`Darwin` → macOS, `/etc/arch-release` → Arch, `/etc/os-release` → Ubuntu)
2. Runs `packages/install.sh <os>`, which reads the OS column of `packages.tsv`,
   groups packages by install method, and installs each group:
   - **macOS** — regenerates `Brewfile` from the manifest, then `brew bundle`
   - **Arch** — `pacman -Syu` + native packages, bootstraps `yay` for AUR, Flatpak for GUI apps
   - **Ubuntu** — apt for native packages, `custom-ubuntu.sh` hooks for tools not in apt
     (mise, kubectl, k9s, yq, AWS/Azure/GCloud CLIs), Flatpak for GUI apps
3. Calls `scripts/setup-ssh.sh` to configure git signing
4. Symlinks `zsh/.zshrc` to `~/.zshrc`

All package definitions live in **`packages.tsv`** (one row per tool, one column
per OS) — see the README for the token format. The `Brewfile` is generated from it.

The `.zshrc` is portable: it resolves the zsh-plugin path per OS, activates `mise`
only if present, and uses the Bitwarden SSH agent socket only when the socket exists.

---

## SSH Keys

Two keys per device, both stored in Bitwarden:

| Key | Purpose |
|---|---|
| `MacBook M3 - Access` | SSH authentication (GitHub, servers) |
| `MacBook M3 - Signing` | Git commit signing |

### Bitwarden SSH Agent

Bitwarden manages the SSH keys via its agent. The socket is configured in `.zshrc`:

```bash
export SSH_AUTH_SOCK=~/.bitwarden-ssh-agent.sock
```

**Settings used:**
- Enable SSH Agent: on
- Authorization prompt: Remember until vault is locked
- Auto-lock: 15 minutes

**Linux note:** the Flatpak Bitwarden desktop sandboxes its socket under
`~/.var/app/com.bitwarden.desktop/...`. Symlink it to `~/.bitwarden-ssh-agent.sock`
(the path `.zshrc` expects) once after first launch, or install the native
`.deb`/AUR build instead of Flatpak if you rely on the SSH agent.

### setup-ssh.sh

Generates `~/.gitconfig` from the dotfiles template, replacing `SIGNING_KEY_PLACEHOLDER` with the device's signing key. Also creates `~/.ssh/allowed_signers` for local commit verification.

Run once per device:
```bash
bash scripts/setup-ssh.sh
```

---

## Git

Commits are signed automatically via SSH. Config is in `git/.gitconfig` (template with placeholder) and written to `~/.gitconfig` by `setup-ssh.sh`.

To verify a signed commit:
```bash
git log --show-signature
```

---

## Runtime versions (mise)

Languages and tools that vary per project (Node, Python, Terraform, etc.) are managed by mise, not installed globally.

To set versions for a project, create a `.mise.toml` in the repo:

```toml
[tools]
node = "22"
terraform = "1.9.0"
```

---

## Containers

- **Podman** is used instead of Docker
- **dtop** for local monitoring: `dtop`
- **dtop** for remote hosts via SSH: `dtop --host ssh://user@host`

To avoid constant Bitwarden auth prompts with dtop over SSH, set the agent authorization to **Remember until vault is locked**.

---

## Passwords & Email aliases

- **Bitwarden** (self-hosted via Vaultwarden) for passwords and SSH keys
- **SimpleLogin** (via Proton account) for email aliases — integrated with Bitwarden username generator

---

## Adding new packages

Always add to `Brewfile` after installing:

```
brew "tool-name"       # CLI tools
cask "app-name"        # GUI apps
```

Runtime versions (Node, Python, Terraform) go in `.mise.toml` per project, not in Brewfile.
