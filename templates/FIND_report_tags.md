> Helps find reports that contain specific tags.

## 1. Reports by tag (YAML + inline)

```dataview
TABLE
    dateformat(period_to, "yyyy-MM-dd") as "Date",
    theme_query as "Focus",
    tags as "Tags"
FROM "standard_queries" OR "specialized_queries"
WHERE contains(tags, "pangenome")
  AND contains(tags, "surveillance")
SORT period_to DESC
```

## 2. Inline tags not yet in YAML frontmatter

```dataviewjs
dv.table(["Report", "Inline Tags"],
    dv.pages('"standard_queries" or "specialized_queries"')
    .map(p => {
        let yamlTags = Array.isArray(p.tags) ? p.tags : [p.tags];
        let inlineOnly = p.file.etags.values.filter(t => {
            let cleanTag = t.replace("#", "");
            return !yamlTags.includes(cleanTag);
        });
        return [p.file.link, inlineOnly];
    })
);
```

## 3. By hashtag combination

```dataview
TABLE
    dateformat(period_to, "yyyy-MM-dd") as "Date",
    theme_query as "Focus"
FROM #amr AND #nextflow
SORT period_to DESC
```
