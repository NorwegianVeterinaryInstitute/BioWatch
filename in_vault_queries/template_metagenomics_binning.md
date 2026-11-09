# Metagenomics binning — worked theme-query example

Shows how to go from a broad vocabulary tag to a specific sub-topic. `binning`
isn't (and doesn't need to be) its own entry in `TAG_VOCABULARY.md` — it's narrow
enough to find with a text search layered on top of the `#metagenomics` tag
instead. Use this as a template for any other theme the same way.

## 1. Every entry tagged #metagenomics

> Base query: any report containing the #metagenomics tag anywhere, newest first.

```dataview
TABLE
    dateformat(period_to, "yyyy-MM-dd") as "Date",
    theme_query as "Focus",
    tags as "Tags"
FROM #metagenomics
SORT period_to DESC
```

## 2. Narrowed to binning specifically

> Same tag, refined with a text search for "binning" in the note body — the
> combination is what makes this a *binning* query rather than a general
> metagenomics one.

```dataview
TABLE
    dateformat(period_to, "yyyy-MM-dd") as "Date",
    theme_query as "Focus"
FROM #metagenomics
WHERE contains(lower(file.content), "binning")
SORT period_to DESC
```

## Building your own theme query

Copy query #2, swap `#metagenomics` for any tag in `TAG_VOCABULARY.md`, and swap
`"binning"` for whatever word narrows it down further (a method name, "wastewater",
a pathogen name, etc.). That's the whole pattern: **vocabulary tag + free-text
refinement** — no need to formalize every sub-topic as its own tag.
