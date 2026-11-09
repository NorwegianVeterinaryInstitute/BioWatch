# In-vault queries — Dataview basics

`in_vault_queries/` doesn't search the web — it searches the reports already sitting
in `automated_findings/` and `specialized_findings/`, using the
[Dataview](https://blacksmithgu.github.io/obsidian-dataview/) plugin. This is a
short primer, not the full Dataview docs.

## How a query finds reports

Every report starts with YAML frontmatter, e.g.:

```yaml
---
report: Bioinformatics Method Scout
run_type: automated
description: Biweekly automated scan — standard focus areas
period_from: 2026-10-26
period_to: 2026-11-09
theme_query: Pathogen Discovery, pLMs, Metagenomics, Assembly, Evolution, Comparative Genomics, AMR
tags: [bioinformatics, pathogen_discovery, pLMs, metagenomics, AMR]
read: false
---
```

A Dataview query reads these fields directly — `period_to`, `tags`, `theme_query`,
`description`, etc. — across every file in one or more folders, and builds a table
from them. It does **not** read the report body unless you specifically ask it to.

## The two kinds of tag, and why it matters

Obsidian has two independent ways a note can be "tagged", and Dataview treats them
differently:

1. **YAML frontmatter tags** — the `tags: [...]` list at the top of the file, as
   above. One broad set per *report* (the standard focus areas for an automated run,
   or the narrowed topic for a specialized one). Query with
   `contains(tags, "...")`.
2. **Inline `#hashtags`** — written in the body. BioWatch uses these **per tool
   entry**: each entry in Section A/B gets its own `Tags: #tag1 #tag2 #tag3` line,
   drawn from the fixed list in `TAG_VOCABULARY.md` (never invented freely — that's
   what keeps them mergeable instead of drifting into near-duplicates). These show
   up in Obsidian's tag pane and graph view, and a Dataview query asks for them
   separately (`file.etags` / `FROM #tag`) since they aren't part of the
   frontmatter.

So it's expected and fine for a report to have several inline tags that never
appear in its frontmatter `tags:` — that's each entry's own tagging, deliberately
more specific than the report-level set. `template_tag_search.md` query #2 is for a
different thing: a genuine hygiene check, for a tag that was clearly meant to
describe the *whole report* but only got added inline, not promoted to frontmatter.

## Minimal query shapes used here

```dataview
TABLE period_to as "Date", theme_query as "Focus"
FROM "automated_findings" OR "specialized_findings"
SORT period_to DESC
```

- `TABLE ... as "..."` — which frontmatter fields to show, and the column header.
- `FROM "folder"` — which folder(s) to search; `OR` combines several.
- `WHERE contains(tags, "amr")` — filter by a YAML tag.
- `FROM #amr AND #nextflow` — filter by inline hashtags instead.
- `SORT period_to DESC` — newest first.

Copy a block from `in_vault_queries/`, change the folder/tag/sort, and it's a new
search — no code needed beyond editing that one line.

## Browsing tags in Obsidian itself

Beyond Dataview, Obsidian's built-in **Tag pane** (sidebar) lists every tag used
anywhere in the vault with a count, and clicking one shows every note/entry using
it — a quick way to browse `TAG_VOCABULARY.md`'s tags in practice without writing a
query at all. It won't stop someone from typing a new tag that isn't in the
vocabulary, though — Obsidian has no built-in "pick from this list only" — so the
vocabulary file plus the agent instruction are what actually keep tags controlled,
not an Obsidian setting.
