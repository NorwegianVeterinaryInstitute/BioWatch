---
type: checklist
updated: 2026-11-09
---

# BioWatch — Review Checklist

Automated reports land here every 2 weeks (`bin/run_biowatch.sh`); specialized ones
get added by whoever runs them (see `AGENT_INSTRUCTIONS.md`). Check off each report
once the group has read/discussed it.

**Tagging during review**: `TAG_VOCABULARY.md` is a fixed list for the *agent's*
per-entry tags, so automated tagging stays mergeable. It doesn't limit you — add
your own `#hashtag` here on a checklist row, or in a note, whenever it's useful
during discussion (a meeting theme, a colleague's name, "revisit-next-cycle",
whatever). Obsidian's Tag pane picks up every tag in the vault regardless of
whether it's in the vocabulary, so this is a good, low-friction way to build up
your own browsable index over time without having to formalize it first.

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
- [ ] [[20251207]] — 2025-11-23 -> 2025-12-07
- [ ] [[20251221]] — 2025-12-07 -> 2025-12-21
- [ ] [[20260104]] — 2025-12-21 -> 2026-01-04
- [ ] [[20260118]] — 2026-01-04 -> 2026-01-18
- [ ] [[20260201]] — 2026-01-18 -> 2026-02-01
