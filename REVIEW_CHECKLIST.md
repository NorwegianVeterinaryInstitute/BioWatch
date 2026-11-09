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

*(fresh start — no backlog carried over from the old prototype repo; the first
batch of reports was also regenerated from scratch on 2026-11-09 to switch to the
list-item entry format Dataview needs for per-finding queries)*
- [ ] [[20261109]] — 2026-10-26 -> 2026-11-09
- [ ] [[20251123]] — 2025-11-09 -> 2025-11-23
- [ ] [[20251207]] — 2025-11-23 -> 2025-12-07
- [ ] [[20251221]] — 2025-12-07 -> 2025-12-21
- [ ] [[20260104]] — 2025-12-21 -> 2026-01-04
- [ ] [[20260118]] — 2026-01-04 -> 2026-01-18
- [ ] [[20260201]] — 2026-01-18 -> 2026-02-01
- [ ] [[20260215]] — 2026-02-01 -> 2026-02-15
- [ ] [[20260301]] — 2026-02-15 -> 2026-03-01
- [ ] [[20260315]] — 2026-03-01 -> 2026-03-15
- [ ] [[20260329]] — 2026-03-15 -> 2026-03-29
- [ ] [[20260412]] — 2026-03-29 -> 2026-04-12
- [ ] [[20260426]] — 2026-04-12 -> 2026-04-26
- [ ] [[20260510]] — 2026-04-26 -> 2026-05-10
- [ ] [[20260524]] — 2026-05-10 -> 2026-05-24
- [ ] [[20260607]] — 2026-05-24 -> 2026-06-07
- [ ] [[20260621]] — 2026-06-07 -> 2026-06-21
- [ ] [[20260705]] — 2026-06-21 -> 2026-07-05
- [ ] [[20260719]] — 2026-07-05 -> 2026-07-19
- [ ] [[20260802]] — 2026-07-19 -> 2026-08-02
- [ ] [[20260816]] — 2026-08-02 -> 2026-08-16
- [ ] [[20260830]] — 2026-08-16 -> 2026-08-30
- [ ] [[20260913]] — 2026-08-30 -> 2026-09-13
- [ ] [[20260927]] — 2026-09-13 -> 2026-09-27
- [ ] [[20261011]] — 2026-09-27 -> 2026-10-11
- [ ] [[20261025]] — 2026-10-11 -> 2026-10-25
- [ ] [[20261026]] — 2026-10-25 -> 2026-10-26
