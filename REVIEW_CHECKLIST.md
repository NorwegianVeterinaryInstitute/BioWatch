---
type: checklist
updated: 2026-11-09
---

# BioWatch — Review Checklist

Reports are generated every 2 weeks by `bin/run_biowatch.sh`.
Check off each report once the group has read/discussed it.

---

## Coverage gap check

```dataview
LIST "Last coverage ended on: " + max(rows.period_to)
FROM "standard_queries"
GROUP BY report
```

---

## 2026

*(fresh start — no backlog carried over from the old prototype repo)*
