---
type: vocabulary
updated: 2026-11-09
---

# Tag vocabulary

The agent tags each tool/entry in a report with **2-3 tags, never more than 5**,
drawn only from this list — not invented freely. A fixed vocabulary keeps tags
mergeable in Obsidian's tag pane and in `in_vault_queries/` instead of fragmenting
(`AMR` vs `amr` vs `antimicrobial-resistance`).

Written as inline `#hashtags` directly under each entry (see `AGENT_INSTRUCTIONS.md`),
so they show up in Obsidian's tag pane/graph view and in Dataview queries against
`file.etags`.

## Topic (pick 1-2 — matches the focus areas in AGENT_INSTRUCTIONS.md)

`#disease-x` `#metagenomics` `#plm` `#assembly` `#annotation` `#evolution`
`#phylogenetics` `#comparative-genomics` `#variant-calling` `#amr` `#one-health`
`#emerging` `#cross-domain`

## Technical (pick 0-2)

`#nextflow` `#snakemake` `#python` `#r-lang` `#docker` `#webserver`

## Status (apply if it matches — doesn't need to displace a Topic/Technical tag,
but keep the total at 5 or under)

`#surveillance-ready` `#experimental`

## Adding a new tag

If nothing here fits a genuinely new topic, add it to this file first (in the right
section, lowercase, hyphenated) before using it — don't let the agent invent one
inline. Keeps this file the single source of truth for what a tag means.
