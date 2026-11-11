# PLANS — BraisenlySwiftUI themable tokens + BraisenlySwiftDemo catalog

Updated 2026-11-11. Coordinator session: "swift storybook" (Claude Fable 5.1).

## Goal

A Storybook-style catalog app (`/Volumes/MACDEV/BraisenlySwiftDemo`, repo `zautke/BraisenlySwiftDemo`) that
lists every BraisenlySwiftUI primitive and compound component in a grouped sidebar, renders each live with typed
knobs, and is built ONLY from package components (zero bare SwiftUI, layout included). Verified live on physical
devices only: presto (iPad Pro 11" M4, iPadOS 27.2, UDID `00008132-001C383636B9001C`) and macOS on largo;
hemoila (iPhone) smoke only. No simulators.

## Phases

| Ph | Work | Status |
|---|---|---|
| 0 | kb hub/ledgers/team cards; repos + worktrees + draft PRs | DONE 2026-11-08 |
| 1 | Inventory + specs + TDD plans; user gate | DONE 2026-11-08 (U-1..U-17 answered) |
| 2 | Package 0.2.0: env-driven theme model, Liquid Glass default, 47+14 view migration, layout wrappers, controls, ThemeSwitcher, floor iOS 26/macOS 26 (28 tasks) | IN PROGRESS — Tasks 1-3 implemented, independent review pending |
| 3 | Demo app scaffold, registry, knobs, lint, completeness test (20 tasks) | not started (needs Phase 2 merged) |
| 4 | Team B Phase 0: presto DDI/tunnel via USB, DeviceInteraction smoke | not started |
| 5 | Live battery presto + macOS (3 themes, every entry), XCUITest on device, metrics | not started |
| 6 | Demo 0.1.0 merge, release records, retro | not started |

## Current facts

- Package `development` = 0.1.0 (111be3f, tag 0.1.0). Feature branch `feat/themable-tokens-and-catalog-primitives`,
  worktree `/Volumes/MACDEV/BraisenlySwiftUI-catalog`, draft PR #7. HEAD a7ee0a1.
- Demo repo bootstrapped; worktree `/Volumes/MACDEV/BraisenlySwiftDemo-scaffold` on `feat/catalog-scaffold`, draft PR #1,
  holds `docs/catalog-inventory.md` and `docs/superpowers/{specs,plans}`.
- Specs/plans primary in kb `projects/braisenly-swiftui/{specs,plans}/`, mirrored in both repos' `docs/superpowers/`.
- Coordinator plan file: `/Users/derp/.claude/plans/use-superpowers-and-caveman-prancy-matsumoto.md`.
- SDD ledger: `.superpowers/sdd/2026-11-08-themable-tokens-and-catalog-primitives/progress.md` (git-ignored).

## Non-goals (this cycle)

- BraisenlyAI catalog group (specced in lockstep, implemented after 0.2.0; needs issue #8 client injection).
- Snapshot-testing dependency. Fixing Codex findings #4 #5 #6 inside the baseline.
