# =============================================================================
# Powerlevel10k instant prompt — must stay near the top, before any output.
# =============================================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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
# Dotfiles config dir — %x is the path of this file being sourced; :A resolves
# the ~/.zshrc symlink back to the repo. ($0 is just "zsh" during startup.)
# =============================================================================
ZSH_CONFIG_DIR="${${(%):-%x}:A:h}"

# =============================================================================
# Completions (compinit must run before zsh-syntax-highlighting below)
# =============================================================================
[[ -f "$ZSH_CONFIG_DIR/completions.zsh" ]] && source "$ZSH_CONFIG_DIR/completions.zsh"

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
# Powerlevel10k theme + config
# =============================================================================
[[ -f ~/.local/share/powerlevel10k/powerlevel10k.zsh-theme ]] \
  && source ~/.local/share/powerlevel10k/powerlevel10k.zsh-theme
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# =============================================================================
# Vendored ohmyzsh plugins (lib helpers first, then the plugins)
# =============================================================================
for _plugin_file in "$ZSH_CONFIG_DIR"/plugins/lib/*.zsh(N) "$ZSH_CONFIG_DIR"/plugins/*.zsh(N); do
  source "$_plugin_file"
done
unset _plugin_file

# =============================================================================
# Aliases (split by topic in zsh/aliases/*.zsh)
# Loaded AFTER plugins so personal overrides win over the omz git aliases.
# =============================================================================
for _alias_file in "$ZSH_CONFIG_DIR"/aliases/*.zsh(N); do
  source "$_alias_file"
done
unset _alias_file
