# REMEMBER (append-only durable facts)

- 2026-11-08 — `development` held only the original 7-file design system until PR #3; the 47 components + BraisenlyAI came from `ai-chat-components`. Do not trust an old codemunch index built from another checkout.
- 2026-11-08 — Full `swift build` of this package compiles mlx-swift/mlx-swift-lm: ~11 min cold, ~1.3 GB `.build`. `swift test` builds the AI test target too. Use `swift build --target BraisenlySwiftUI` for core-only loops.
- 2026-11-08 — Public-views extraction: `swift symbolgraph-extract -module-name BraisenlySwiftUI -target arm64-apple-macos26.0 -I .build/debug/Modules -I .build/debug -sdk "$(xcrun --show-sdk-path --sdk macosx)" -output-dir <dir> -minimum-access-level public` (target must be macos26.0 after the floor bump; `-Xswiftc -emit-symbol-graph` emits nothing).
- 2026-11-08 — presto (iPad Pro 11" M4, iPadOS 27.2, UDID 00008132-001C383636B9001C): Developer Mode on, paired, transport localNetwork, tunnel disconnected, DDI unavailable until USB.
- 2026-11-08 — Liquid Glass API (`glassEffect`, `GlassEffectContainer`, `glassEffectID/Union/Transition`, `.buttonStyle(.glass)`) unchanged from iOS 26 to iOS 27; glass is for controls/navigation only; `Glass` is Sendable in the 27.2 SDK.
- 2026-11-08 — Release record surfaces for every bump: kb project release log, kb org log (table row, newest first, 7 columns), project memory `BraisenlySwiftUI_release_log.md`, global memory `~/.claude/projects/-Users-derp/memory/release_log.md`.
- 2026-11-08 — Signing: Apple Development team YTQKFYB8RZ. xcodegen 2.44.1 present; no Tuist.
- 2026-11-11 — SDD ledger is git-ignored under `.superpowers/sdd/<plan>/progress.md`; a `git clean -fdx` destroys it. Recover from `git log` + this file.
