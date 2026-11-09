# Agent query types

The two kinds of query you can ask the scout *agent* to run — not to be confused with
`in_vault_queries/`, which searches reports already in the vault.

## automated_findings/

The regular, biweekly scout run. Always the same focus areas (see
`AGENT_INSTRUCTIONS.md`), run by `bin/run_biowatch.sh` on a schedule. Filename is the
period's end date, `YYYYMMDD.md` — sorts correctly on its own.

## specialized_findings/

A one-off, narrower run on something an automated run wouldn't catch well — e.g. "only
long-read assembly tools" or "anything new on H5N1 specifically." Anyone (Eve or a
colleague) can run one with their own agent:

1. Take `AGENT_INSTRUCTIONS.md` as the base prompt.
2. Narrow the focus areas / add the specific question.
3. Ask the agent to write the result into `specialized_findings/` with the same report
   format and frontmatter fields (period_from/period_to/tags/read matter for Dataview
   — don't drop them).
4. Give the file a descriptive name, e.g. `2026-11-23_h5n1_methods.md`.

See `howto/specialized-query-example.md` for a worked example — you only write the
narrowing instructions, not a new prompt from scratch.

Both folders use the same frontmatter schema, so the Dataview queries in
`in_vault_queries/` search across both at once.
