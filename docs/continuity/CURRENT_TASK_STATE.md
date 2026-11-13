# CURRENT TASK STATE (rewrite in place)

As of 2026-11-12 17:40.

- Where: `/Volumes/MACDEV/BraisenlySwiftUI`, branch `development`, HEAD = 0.3.0 merge `7e7be35` (PR #9 fix/sidebar-layout; Codex no findings; four release surfaces + run ledger RUN 2026-11-12 #2 written).
- Phase 3 (demo) in `/Volumes/MACDEV/BraisenlySwiftDemo-scaffold`, branch `feat/catalog-scaffold` (draft PR #1), HEAD 5b12c7d: Tasks 1–17 committed and pushed (scaffold, lint, model, shell, 12 groups / 71 entries, completeness test). Task 18 (CatalogWalkTests) + Task 19 (README, CHANGELOG 0.1.0) written and staged, uncommitted until the UI walk passes.
- BLOCKED on user: (1) `sudo /usr/bin/automationmodetool enable-automationmode-without-authentication` — macOS XCTest automation mode times out unattended; (2) presto shows `unavailable` in devicectl (wake/unlock/USB).
- Then: run mac UI walk (`xcodebuild test … -only-testing:BraisenlySwiftDemoUITests`, result bundle under `build/xcresult/`), presto walk, commit 18+19, Task 20 final verification (`scripts/check.sh`, deploy-presto, three-theme mac shots, AI stub report), demo PR → development 0.1.0 with four release surfaces, then Phase 4/5.
- Lesson: never run parallel xcodebuilds on largo (five concurrent runs hit load 485 and 1.2 GiB boot disk). One build at a time; subagent fan-out for Swift tasks must serialize builds.
- Open: package issues #4 #5 #6 #8; `/Volumes/MACDEV/BraisenlySwiftUI-fix-lfm3` (user's 9 uncommitted files) untouched.
