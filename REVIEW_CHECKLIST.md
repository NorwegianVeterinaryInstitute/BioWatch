---
type: checklist
updated: 2026-11-09
---

# BioWatch — Review Checklist

Automated reports land here every 2 weeks (`bin/run_biowatch.sh`); specialized ones
get added by whoever runs them (see `AGENT_INSTRUCTIONS.md`). Check off each report
once the group has read/discussed it.

---

## Coverage gap check

```dataview
LIST "Last coverage ended on: " + max(rows.period_to)
FROM "automated_findings"
GROUP BY report
```

---

## 2026

*(fresh start — no backlog carried over from the old prototype repo)*
- [ ] [[20261109]] — 2026-10-26 -> 2026-11-09
