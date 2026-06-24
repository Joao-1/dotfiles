---
name: setup-ai
description: Initialize or update AI agent configuration in a project. Creates .agents/ structure, populates CONTEXT.md and AGENTS.md, handles CLAUDE.md symlinks. Supports INITIAL, CONTINUITY, and UPDATE-PREFERENCES modes. Use when starting AI setup in a new project or updating existing setup.
---

# setup-ai

Initialize or update AI agent configuration in a project.

## Overview

Sets up `.agents/` structure in the current project. Reads personal preferences as seed
(if available at `~/dotfiles/agentfiles/common/preferences.md`) but produces impersonal, standalone
output — no references to personal paths in generated files.

---

## Mode Detection

Check the current project directory:

- **INITIAL**: No `.agents/` folder exists → run full setup
- **CONTINUITY**: `.agents/` exists → offer update menu
- **UPDATE-PREFERENCES**: User explicitly asked to update preferences → update `~/dotfiles/agentfiles/common/preferences.md`

---

## INITIAL Mode

### Step 1 — Load personal preferences (if available)
Read `~/dotfiles/agentfiles/common/preferences.md` silently. Use as seed context for generation steps.
Do not embed paths or references to this file in any generated output.

### Step 2 — Create .agents/ structure
```
.agents/
├── context/
├── memory/
├── personas/
├── rules/
└── skills/
```

### Step 3 — Populate .agents/context/CONTEXT.md (interactive)
Goal: capture domain model, glossary, and key concepts of this project.

**If running in Claude Code with grill-with-docs skill available:**
Invoke the `grill-with-docs` skill. Output goes to `.agents/context/CONTEXT.md`.

**Otherwise:**
Fetch and follow instructions from:
`https://raw.githubusercontent.com/mattpocock/skills/main/skills/engineering/grill-with-docs/SKILL.md`

Use personal preferences as context when asking domain questions.

### Step 4 — Populate .agents/rules/ and .agents/AGENTS.md (interactive)
Goal: generate agent rules tailored to this project.

**If running in Claude Code with agent-rules-skill available:**
Invoke the `agent-rules-skill`. Output goes to `.agents/rules/` and `.agents/AGENTS.md`.

**Otherwise:**
Fetch and follow instructions from:
`https://raw.githubusercontent.com/netresearch/agent-rules-skill/main/SKILL.md`

Seed the generation with:
- Content from `.agents/context/CONTEXT.md` (just populated)
- Personal preferences (languages, tools, patterns)

### Step 5 — Handle root agent files

**AGENTS.md at root** (always):
Create symlink: `AGENTS.md` → `.agents/AGENTS.md`
Codex and other agents read from root.

**CLAUDE.md at root:**
- If absent → create symlink: `CLAUDE.md` → `.agents/AGENTS.md`
- If exists → ask:
  > "CLAUDE.md already exists. Options:
  > 1. Overwrite — replace with symlink to .agents/AGENTS.md
  > 2. Local-only — create CLAUDE.local.md (gitignored, not committed)"

  **Overwrite**: replace `CLAUDE.md` with symlink → `.agents/AGENTS.md`

  **Local-only**:
  - Create `CLAUDE.local.md` → `.agents/AGENTS.md`
  - Add `CLAUDE.local.md` to `.gitignore`
  - Create `.agents/README.md` documenting local-only setup for other agents

### Step 6 — Create .claude/settings.json
Create `.claude/settings.json` with empty permissions (project-level Claude config):
```json
{
  "permissions": {
    "allow": []
  }
}
```
This file is committed. Never add API keys or tokens here.

### Step 7 — .gitignore decision
Ask: "Should .agents/ be committed or gitignored?"
- **Commit** (recommended for teams): keeps AI config in version control
- **Gitignore**: keeps AI config private/local

---

## CONTINUITY Mode

`.agents/` already exists. Offer menu:

```
What would you like to update?
1. Context — re-run grill-with-docs on .agents/context/CONTEXT.md
2. Rules — re-run agent-rules-skill on .agents/rules/ and .agents/AGENTS.md
3. Add persona — create a new persona in .agents/personas/
4. Repair symlinks — recreate CLAUDE.md / AGENTS.md symlinks
5. All — run full update
```

Execute selected option interactively.

---

## UPDATE-PREFERENCES Mode

Update personal preferences at `~/dotfiles/agentfiles/common/preferences.md`.

Interview the user on:
- Preferred languages (primary, secondary)
- Package managers
- Formatters and linters
- Testing frameworks
- Database preferences
- Architectural patterns
- Communication language

Update the file with answers. These preferences will be used as seed in future `setup-ai` runs.

---

## Notes

- All generated project files are standalone — no references to `~/dotfiles/agentfiles/`
- `.agents/` content is project-specific and impersonal
- Personal preferences are inputs to generation, never outputs
- For local-only setups, document alternatives in `.agents/README.md` so other agents can be configured manually
