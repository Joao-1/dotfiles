# Mac Setup Guide

## Fresh install

```bash
git clone https://github.com/joaovitor/dotfiles ~/dotfiles
cd ~/dotfiles
bash setup.sh
source ~/.zshrc
```

---

## What setup.sh does

1. Installs Homebrew if not present
2. Runs `brew bundle` to install all packages from `Brewfile`
3. Calls `scripts/setup-ssh.sh` to configure git signing
4. Symlinks `zsh/.zshrc` to `~/.zshrc`

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
