#!/usr/bin/env bash
set -euo pipefail

AGENTFILES="$(cd "$(dirname "$0")" && pwd)"
BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

log()  { echo -e "${GREEN}✓${RESET} $1"; }
warn() { echo -e "${YELLOW}!${RESET} $1"; }
header() { echo -e "\n${BOLD}$1${RESET}"; }

symlink() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  ln -sf "$src" "$dst"
  log "linked $dst → $src"
}

# ── Claude Code ──────────────────────────────────────────────────────────────
setup_claude_code() {
  header "Claude Code"
  local claude_dir="$HOME/.claude"
  local src="$AGENTFILES/agents/claude-code"

  symlink "$src/settings.json" "$claude_dir/settings.json"
  symlink "$src/CLAUDE.md"     "$claude_dir/CLAUDE.md"

  # Custom skills: each subfolder in common/skills/ becomes a skill
  local skills_src="$AGENTFILES/common/skills"
  local skills_dst="$claude_dir/skills"
  mkdir -p "$skills_dst"
  for skill_dir in "$skills_src"/*/; do
    local skill_name
    skill_name="$(basename "$skill_dir")"
    symlink "$skill_dir" "$skills_dst/$skill_name"
  done

  # Install external skills via claude plugin (for plugins) and skill manager
  install_skills_claude
}

install_skills_claude() {
  header "External Skills (Claude Code)"

  # Install caveman plugin if not present
  if claude plugin list 2>/dev/null | grep -q "caveman"; then
    log "caveman plugin already installed"
  else
    warn "caveman plugin not installed — run: claude plugin install caveman@caveman"
  fi

  # For mattpocock skills: they require running /setup-matt-pocock-skills in a session
  # Check if already installed
  if [ -f "$HOME/.agents/.skill-lock.json" ] && grep -q "grill-with-docs" "$HOME/.agents/.skill-lock.json" 2>/dev/null; then
    log "mattpocock skills already installed"
  else
    warn "mattpocock skills not installed — open Claude Code and run: /setup-matt-pocock-skills"
  fi

  # agent-rules-skill from netresearch marketplace
  if claude plugin list 2>/dev/null | grep -q "agent-rules" || \
     [ -f "$HOME/.agents/.skill-lock.json" ] && grep -q "agent-rules" "$HOME/.agents/.skill-lock.json" 2>/dev/null; then
    log "agent-rules-skill already installed"
  else
    warn "agent-rules-skill not installed — open Claude Code and run: /find-skills agent-rules"
  fi
}

# ── Main ──────────────────────────────────────────────────────────────────────
header "agentfiles install"
echo "Source: $AGENTFILES"

if command -v claude &>/dev/null; then
  setup_claude_code
else
  warn "claude not found — skipping Claude Code setup"
fi

header "Done"
echo "Restart Claude Code to apply changes."
