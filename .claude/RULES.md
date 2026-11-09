# BioWatch — working rules

Loaded automatically into every Claude Code session in this repo via `CLAUDE.md`.

## Commits

Every commit follows [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/).

## Issues are the record of problems

- Found a problem, bug, or missing feature → open a GitHub issue describing it
  (what's wrong, what it should do instead).
- Fixing it → reference the issue in the commit/PR (e.g. `Fixes #12`) and close it
  once merged.
- **Colleague-facing issues go on the NVI repo**
  ([NorwegianVeterinaryInstitute/BioWatch](https://github.com/NorwegianVeterinaryInstitute/BioWatch)).
  Eve's own fork issues are personal notes, not synced (see `README.md`).

## Naming convention for findings — enforced in AGENT_INSTRUCTIONS.md

- `automated_findings/<period_to as YYYYMMDD>.md` — ISO 8601 **basic** format, no
  separators (e.g. `20261123.md`).
- `specialized_findings/<period_to as YYYY-MM-DD>_<short-slug>.md` — ISO 8601
  **extended** format (with dashes) plus a lowercase, hyphen-separated slug
  (e.g. `2026-11-23_h5n1_methods.md`).

Both sort correctly as plain filenames and avoid DD-MM/MM-DD ambiguity. The agent
is instructed to pick the right one based on `run_type` — see
`AGENT_INSTRUCTIONS.md`.

## No separate task list

There is no `TASKS.md` — the GitHub issue tracker on the NVI repo is the only
backlog. Anything discovered that isn't being done right now becomes an issue, not a
line in a file; a closed issue is the done-list.
