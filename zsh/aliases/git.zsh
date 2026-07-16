# Git — personal overrides.
# The full alias set comes from the vendored ohmyzsh git plugin (plugins/git.plugin.zsh).
# These four keep MY meaning where it differs from omz (omz: gc=commit -v, gl=pull,
# gst=status, gca=commit -v -a). This file loads after the plugin, so it wins.
alias gc="git commit -m"
alias gca="git commit --amend"
alias gl="git log --oneline --graph --decorate"
alias gst="git stash"
