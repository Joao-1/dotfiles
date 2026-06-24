# =============================================================================
# PATH (mise and other tools install here on Linux)
# =============================================================================
export PATH="$HOME/.local/bin:$PATH"

# =============================================================================
# mise — runtime version manager
# =============================================================================
command -v mise &>/dev/null && eval "$(mise activate zsh)"

# =============================================================================
# Bitwarden SSH Agent
# =============================================================================
[[ -S ~/.bitwarden-ssh-agent.sock ]] && export SSH_AUTH_SOCK=~/.bitwarden-ssh-agent.sock

# =============================================================================
# Zsh plugins (path differs across Mac/Arch/Ubuntu)
# =============================================================================
if command -v brew &>/dev/null; then
  ZSH_PLUGIN_DIR="$(brew --prefix)/share"      # macOS (Homebrew)
elif [[ -d /usr/share/zsh/plugins ]]; then
  ZSH_PLUGIN_DIR="/usr/share/zsh/plugins"      # Arch
else
  ZSH_PLUGIN_DIR="/usr/share"                  # Ubuntu/Debian
fi
[[ -f "$ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] \
  && source "$ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -f "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] \
  && source "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# =============================================================================
# Git aliases
# =============================================================================
alias g="git"
alias gs="git status"
alias ga="git add"
alias gaa="git add --all"
alias gc="git commit -m"
alias gca="git commit --amend"
alias gp="git push"
alias gpl="git pull"
alias gf="git fetch"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gb="git branch"
alias gbd="git branch -d"
alias gl="git log --oneline --graph --decorate"
alias gd="git diff"
alias gds="git diff --staged"
alias gst="git stash"
alias gstp="git stash pop"

# =============================================================================
# Kubectl aliases
# =============================================================================
alias k="kubectl"
alias kgp="kubectl get pods"
alias kgs="kubectl get services"
alias kgd="kubectl get deployments"
alias kgn="kubectl get nodes"
alias kga="kubectl get all"
alias kd="kubectl describe"
alias kdp="kubectl describe pod"
alias kds="kubectl describe service"
alias kdd="kubectl describe deployment"
alias kl="kubectl logs"
alias klf="kubectl logs -f"
alias ke="kubectl exec -it"
alias ka="kubectl apply -f"
alias kdel="kubectl delete"
alias kns="kubectl config set-context --current --namespace"
alias kctx="kubectl config use-context"
alias kctxs="kubectl config get-contexts"
