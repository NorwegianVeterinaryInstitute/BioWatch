# BioWatch

BioWatch: a lifeguard for busy bioinformaticians — staying afloat on the
bioinformatics methods tide, so you never drown and only swim toward what's worth
your time.

## What this is

A small group of bioinformaticians (different specialities, limited reading time)
keeping up with new methods and tools together instead of each person scanning the
literature alone. Every 2 weeks (configurable), an AI agent scouts bioRxiv, GitHub,
GitLab and PubMed for new/updated bioinformatics methods and writes a short,
structured report. The reports build into a searchable Obsidian vault (this repo),
and the group reviews/discusses them in a recurring meeting.

## Structure

- `standard_queries/` — the regular biweekly reports, one file per cycle.
- `specialized_queries/` — one-off, narrower runs anyone can request on their own
  topic (see `howto/query-types.md`).
- `AGENT_INSTRUCTIONS.md` — the prompt behind every report. Self-contained; point
  your own agent at it to run a query.
- `templates/` — Dataview queries for browsing/searching reports.
- `REVIEW_CHECKLIST.md` — track what's been read/discussed.
- `TASKS.md` — project task list.
- `bin/run_biowatch.sh` — the scheduled-run script (Eve's machine; see `TASKS.md`
  for moving this to GitHub Actions so it doesn't depend on one person's laptop).

## Using this as an Obsidian vault

1. Clone this repo.
2. Open the cloned folder as a vault in Obsidian (not inside another vault — keep it
   standalone).
3. Install these community plugins (Settings → Community plugins → Browse), matching
   `.obsidian/community-plugins.json`. Several plugins share similar names, so check
   the author shown in the browser to get the right one:

   | Plugin | Plugin ID | Author |
   | :--- | :--- | :--- |
   | Dataview | `dataview` | Michael Brenan (blacksmithgu) |
   | Tag Folder | `obsidian-tagfolder` | check author shown in-app — do not confuse with a similarly-named plugin |
   | Colored Tags | `colored-tags` | check author shown in-app — do not confuse with a similarly-named plugin |
   | Advanced Tables | `table-editor-obsidian` | Tony Grosinger (tgrosinger) — plugin ID still says "table-editor-obsidian" from an earlier name; **not** the separate "Markdown Table Editor" plugin |

   Plugin binaries aren't committed to this repo — install them fresh, works the
   same on any OS.
4. Browse `templates/` for ready-made searches, or write your own Dataview query
   against `standard_queries/`/`specialized_queries/`.

## Contributing a specialized query

See `howto/query-types.md`. Short version: take `AGENT_INSTRUCTIONS.md`, narrow it to
your question, run it with your own agent, save the result into
`specialized_queries/` with the same frontmatter fields so it's still searchable.

## Issues

- **Colleague-facing issues**: [NorwegianVeterinaryInstitute/BioWatch](https://github.com/NorwegianVeterinaryInstitute/BioWatch) —
  the canonical, shared repo. Colleagues file issues there.
- **Eve's own fork** ([evezeyl/BioWatch](https://github.com/evezeyl/BioWatch)) keeps a
  separate issues list for personal notes/backlog. GitHub does not sync issues
  between a fork and its upstream — this is by design, not a gap to fix. Anything
  that should reach colleagues gets filed (or re-filed) on the NVI repo directly.

## License

Apache 2.0 (see `LICENSE`).
