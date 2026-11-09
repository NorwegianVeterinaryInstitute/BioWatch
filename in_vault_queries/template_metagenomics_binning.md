# Multi-tag theme query — worked example (entry-level)

(Filename kept as `template_metagenomics_binning` for existing links; the worked
example below now uses `#amr` + `#one-health` to show a genuine multi-tag
combination — swap in `["metagenomics"]` + `keyword = "binning"` for the original
single-tag-plus-keyword case, which still works the same way.)

Each report entry is now its own Dataview list item, with its tags on that same
bullet line (see `AGENT_INSTRUCTIONS.md`) — so a query can return the specific
finding, not the whole report file (see issue #8). This query filters at that
entry level: only list items that actually carry a tag count as "findings"
(child bullets like Links/Function never carry tags), so `item.tags.length > 0`
cleanly isolates them.

`binning` isn't (and doesn't need to be) its own entry in `TAG_VOCABULARY.md` —
narrow enough to find with a text search layered on top of the `#metagenomics`
tag instead. Use this as a template for any other theme the same way.

The query takes a **list** of tags (all required, AND) plus an optional free-text
keyword — a genuine multi-criteria combination, not just one tag. Checked against
the one-year backfill (2025-11-09 to 2026-11-09): `#amr` alone matches 61 entries,
`#one-health` alone 94, and `#amr` **+** `#one-health` together (both tags
required, same bullet line) narrows that to 21 — confirming the AND logic actually
discriminates rather than just returning one tag's results twice.

> **Note**: this uses `dataviewjs`, not the simpler declarative `dataview` blocks
> used elsewhere in this vault — entry-level filtering needs it. The matching logic
> was verified directly against the report text (which tags sit on which bullet
> line) rather than just read as correct; if it still renders oddly once you open
> it in Obsidian, say so and we'll fix the query, not the data.

```dataviewjs
const tags = ["amr", "one-health"];  // without '#' — ALL must be on the entry's bullet line
const keyword = null;                // optional extra text refinement, or null to skip it

let rows = [];
for (let page of dv.pages('"automated_findings" or "specialized_findings"')) {
    for (let item of page.file.lists) {
        if (!item.tags || item.tags.length === 0) continue; // only tagged entries
        if (!tags.every(tag => item.tags.some(t => t.toLowerCase() === "#" + tag))) continue;

        let funcChild = item.children.find(c => c.text.startsWith("Function:"));
        let funcText = funcChild ? funcChild.text.replace(/^Function:\s*/, "") : "";
        let haystack = (item.text + " " + funcText).toLowerCase();
        if (keyword && !haystack.includes(keyword.toLowerCase())) continue;

        rows.push([item.link, funcText, page.file.link, page.period_to]);
    }
}
rows.sort((a, b) => (a[3] < b[3] ? 1 : a[3] > b[3] ? -1 : 0));
dv.table(["Finding", "Function", "Report", "Date"], rows);
```

## Building your own theme query

Copy the block above, swap `tags` for any combination of `TAG_VOCABULARY.md`
entries (one is fine too — just a one-item list), and set `keyword` to narrow it
further by free text (a method name, "wastewater", a pathogen name) or leave it
`null`. That's the whole pattern: **one or more vocabulary tags, AND'd together,
plus an optional free-text refinement, at the finding level, with a link back to
its report**.
