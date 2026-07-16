# CLI completions — cache the output of tools that follow the
# `<tool> completion zsh` convention (kubectl, argocd, helm, mise, podman...).
# Cached once to ~/.cache/zsh/completions; delete a _<tool> file to refresh it.

() {
  local cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/completions"
  mkdir -p "$cache"
  fpath=("$cache" $fpath)

  local tool
  for tool in kubectl argocd helm mise podman istioctl k9s; do
    (( $+commands[$tool] )) || continue
    [[ -f "$cache/_$tool" ]] || "$tool" completion zsh >| "$cache/_$tool" 2>/dev/null
  done
}

autoload -Uz compinit
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"

# OpenTofu uses the tofu binary as its own completion provider (bash-style),
# so it needs bashcompinit rather than the `<tool> completion zsh` convention.
if (( $+commands[tofu] )); then
  autoload -Uz bashcompinit && bashcompinit
  complete -C tofu tofu
fi
