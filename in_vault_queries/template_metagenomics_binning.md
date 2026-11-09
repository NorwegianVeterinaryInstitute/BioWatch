# Metagenomics binning — worked theme-query example (entry-level)

Each report entry is now its own Dataview list item, with its tags on that same
bullet line (see `AGENT_INSTRUCTIONS.md`) — so a query can return the specific
finding, not the whole report file (see issue #8). This query filters at that
entry level: only list items that actually carry a tag count as "findings"
(child bullets like Links/Function never carry tags), so `item.tags.length > 0`
cleanly isolates them.

`binning` isn't (and doesn't need to be) its own entry in `TAG_VOCABULARY.md` —
narrow enough to find with a text search layered on top of the `#metagenomics`
tag instead. Use this as a template for any other theme the same way.

> **Note**: this uses `dataviewjs`, not the simpler declarative `dataview` blocks
> used elsewhere in this vault — entry-level filtering needs it. Written against
> Dataview's documented list-item API, but not yet confirmed rendering correctly
> in a live vault — if it errors or looks wrong once reports exist, say so and
> we'll fix the query, not the data.

```dataviewjs
const tag = "metagenomics";     // without '#' — any TAG_VOCABULARY.md tag
const keyword = "binning";      // set to null to skip the text refinement

let rows = [];
for (let page of dv.pages('"automated_findings" or "specialized_findings"')) {
    for (let item of page.file.lists) {
        if (!item.tags || item.tags.length === 0) continue; // only tagged entries
        if (!item.tags.some(t => t.toLowerCase() === "#" + tag)) continue;

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

Copy the block above, swap `tag` for any `TAG_VOCABULARY.md` entry, and swap
`keyword` for whatever narrows it down further (a method name, "wastewater", a
pathogen name) — or set `keyword = null` to drop the text refinement entirely and
just list every entry with that tag. That's the whole pattern: **vocabulary tag +
optional free-text refinement, at the finding level, with a link back to its
report**.
