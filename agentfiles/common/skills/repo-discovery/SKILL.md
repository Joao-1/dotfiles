---
name: repo-discovery
description: Run an SRE/DevOps discovery across all repos under ./repos and produce a documentation set. Writes discovery-docs/ with per-repo files, an overview, tech stack inventory, and SRE/DevOps notes. Use when documenting or auditing an organization's technical estate.
---

## Subagent definition

Before spawning any subagent in Phase 2, read the repo-analyzer agent definition from:
~/.claude/skills/repo-discovery/agents/repo-analyzer.md

Use the full content of that file as the prompt for each Task subagent. Pass the
repo path as context in each invocation.

---

You are the orchestrator for a technical discovery of an organization whose
repositories live under ./repos, one subdirectory per repo. You coordinate
per-repo analysis and then synthesize the results. Keep your own context lean.
Never read repo source yourself. Delegate that to subagents.

Phase 1, inventory. List every repository under ./repos. Build a repo map with
each repo name and a one-line guess at its type. Create the discovery-docs and
discovery-docs/repos directories.

Phase 2, fan out. For each repo, launch a repo-analyzer subagent via the Task
tool, passing the repo path. Each one writes discovery-docs/repos/<name>.md and
returns only its compact digest. Launch them in batches so several run in
parallel without overloading. Collect every digest and do not proceed until all
repos are covered.

Phase 3, synthesize. Using only the collected digests and the per-repo files on
disk, write in English:

- discovery-docs/00-overview.md with an executive summary of what the
  organization builds, a high-level architecture view, and a table mapping
  every repo to type, purpose, and main stack.
- discovery-docs/tech-stack.md with a consolidated inventory across all repos:
  languages, frameworks, IaC, containers and orchestration, CI/CD, cloud
  services, data stores, and observability, with which repos use each.
- discovery-docs/sre-devops-notes.md with an SRE/DevOps reading of the estate:
  deployment and CI/CD maturity, observability coverage, infrastructure
  consistency, cross-repo dependencies stitched from the digests, notable
  risks, and gaps. Separate stated facts from inferred ones.

Formatting rules for all files: clean prose, no em dash, avoid frequent
parentheses, no unnecessary bold, no blank line between a heading and the
content right after it, blank lines only before lists, and no backtick
formatting in prose.

Finish with a short chat summary: repos covered, dominant stacks, and the three
most important SRE/DevOps findings.
