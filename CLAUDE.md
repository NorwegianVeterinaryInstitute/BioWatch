# BioWatch — repo instructions

@.claude/RULES.md

BioWatch is an Obsidian vault + automation that tracks new bioinformatics methods,
tools and pipelines on a biweekly cadence, so a small group of bioinformaticians can
screen them together instead of each person trying to keep up alone.

## What this repo is

- An **Obsidian vault** (root of this repo) for Eve and colleagues.
- A **scout agent** (`AGENT_INSTRUCTIONS.md`) that any AI agent (Claude, Gemini, etc.)
  can run against bioRxiv/GitHub/GitLab/PubMed to produce one report per cycle.
- A small **automation script** (`bin/run_biowatch.sh`) that runs the scout agent on a
  schedule and writes the result as a new file.

## Structure

- `automated_findings/` — one file per regular biweekly run, named `YYYYMMDD.md`
  (the run's end date), sorts correctly by filename.
- `specialized_findings/` — ad hoc runs, by Eve or colleagues, on a narrower topic.
  Same report format, free-form filename (see `.claude/RULES.md` for the naming
  convention, enforced in `AGENT_INSTRUCTIONS.md`).
- `in_vault_queries/` — Dataview queries for browsing/searching reports by tag, date, or
  coverage gap (see `howto/in-vault-queries-dataview-basics.md`).
- `REVIEW_CHECKLIST.md` — one row per report; check it off once read. Updated
  automatically by `bin/run_biowatch.sh` after each run.
- `AGENT_INSTRUCTIONS.md` — the canonical scout prompt. This is the single source of
  truth for what the agent searches and how it formats output; update it here, not in
  a copy elsewhere.
- `bin/run_biowatch.sh` — the script a scheduler (cron/systemd) calls.

## Report format

Each report is a Markdown file with YAML frontmatter (`run_type`, `description`,
`period_from`, `period_to`, `date_search`, `theme_query`, `tags`, `read: false`).
The frontmatter exists
specifically so the Dataview plugin can query/filter/sort reports as a database —
don't drop or rename these fields without updating `in_vault_queries/*.md` to match.

## Conventions

- Reports are **generated content** — written by the scout agent, not hand-edited
  (fix the prompt in `AGENT_INSTRUCTIONS.md` instead, then re-run).
- Conventional Commits for every commit (see
  https://www.conventionalcommits.org/en/v1.0.0/).
- No backlog carried over from the old prototype repo — BioWatch starts fresh from
  its first real run.
- See `.claude/RULES.md` for the commit, issue, and task-list workflow.
