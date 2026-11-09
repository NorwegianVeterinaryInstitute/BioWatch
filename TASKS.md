# BioWatch — task list

## Now

- [ ] Confirm biweekly cadence and re-enable the scheduled run (systemd timer,
      pointed at this repo's `standard_queries/`)
- [ ] Decide auto-commit vs manual commit after each scheduled run
- [ ] Trim `.obsidian/community-plugins.json` to the plugins actually needed
- [ ] Invite colleagues, confirm they can clone + open as an Obsidian vault
- [ ] First real biweekly meeting: agree how flagged articles get logged
      (GitHub issue? a tag in the report? a shared note?)

## Later

- [ ] Wire in bioRxiv/PubMed MCP tools for the scout run, not WebSearch-only
- [ ] Consider GitHub Actions for the scheduled run instead of a local systemd timer,
      so it doesn't depend on Eve's machine being on
