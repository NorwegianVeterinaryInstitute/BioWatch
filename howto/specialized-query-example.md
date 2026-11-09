# Example: adapting the prompt for a specialized query

You don't rewrite `AGENT_INSTRUCTIONS.md` — you hand your agent the whole file as-is,
then add a short block on top narrowing what this particular run is about. Everything
else (quality filters, output format, frontmatter fields) stays the same, so the
result is still searchable alongside every other report.

Paste `TAG_VOCABULARY.md` in too, not just a reference to it — an agent asked to tag
entries "from TAG_VOCABULARY.md" without the file actually in front of it tends to
invent plausible-sounding tags instead of going to look it up.

## Template

```
<paste the full contents of AGENT_INSTRUCTIONS.md here>

<paste the full contents of TAG_VOCABULARY.md here>

## This run — complementary instructions
- Narrow focus: <what you actually want this time>
- period_from: <date>
- period_to: <date>
- output_file: specialized_findings/<descriptive-name>.md
```

## Worked example

Say you only want long-read assembly tools for oomycetes from the last month —
everything else in the base prompt still applies (filters, Section A/B split, table):

```
<...AGENT_INSTRUCTIONS.md...>

## This run — complementary instructions
- Narrow focus: only long-read (PacBio HiFi/ONT) assembly and haplotype-phasing
  tools for oomycetes or other difficult/repetitive genomes. Skip the other focus
  areas in AGENT_INSTRUCTIONS.md for this run.
- period_from: 2026-10-10
- period_to: 2026-11-10
- output_file: specialized_findings/2026-11-10_oomycete_longread_assembly.md
```

That's the whole adaptation — three lines plus a filename. The agent still applies
the shared quality bar and writes the same report shape, so `in_vault_queries/` keeps
finding it.
