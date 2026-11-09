# Overview

One Dataview query: every report across `automated_findings/` and
`specialized_findings/`, newest first, with its focus area and tags — the
single table to glance at to see what's been found so far.

```dataview
TABLE period_to as "Report Date", theme_query as "Focus", tags as "Keywords"
FROM "automated_findings" OR "specialized_findings"
SORT period_to DESC
```
