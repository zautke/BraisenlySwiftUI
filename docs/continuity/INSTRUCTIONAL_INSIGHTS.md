# INSTRUCTIONAL INSIGHTS (append-only)

- 2026-11-08 — Verify the branch premise before planning: `git ls-tree -r --name-only <branch> | grep -c swift$` per branch. A stale codemunch index built from a different checkout made `development` look complete.
- 2026-11-08 — Review-bot triage on a baseline merge: genuine findings in pre-existing code become issues with a one-line reply on each thread; the baseline PR stays scoped.
- 2026-11-08 — On largo, run `df -h /Volumes/MACDEV` before any SwiftPM build; one full build eats ~1.3 GB. Decide parallel vs serial from free space, and record the ruling in the SDD ledger.
- 2026-11-08 — Subagents may not have the codemunch MCP; brief them with a Read/Grep fallback so they do not stall.
- 2026-11-09/11 — Subagents and their reviews die with the session. Record every dispatch AND every verdict in the ledger immediately; otherwise the next session cannot tell reviewed from unreviewed commits.
- 2026-11-08 — kb org release log is a table; appending a bare row lands outside it. Read the note body before `bm_edit append`.
