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
   above. This is what `in_vault_queries/template_overview.md` and most of
   `template_tag_search.md` query with `contains(tags, "...")`.
2. **Inline `#hashtags`** — written anywhere in the note body, e.g. `#pangenome`.
   These show up in Obsidian's tag pane and graph view too, but a Dataview query has
   to ask for them separately (`file.etags` / `FROM #tag`), because they aren't part
   of the frontmatter.

`template_tag_search.md` query #2 specifically checks for inline tags that were
never added to the YAML list — useful to catch tags added by hand in the report body
that the structured frontmatter search would otherwise miss.

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
