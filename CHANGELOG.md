# Changelog

All notable changes to BraisenlySwiftUI. Versions follow MAJOR.MINOR.PATCH; merges into `development` bump MINOR, promotions to `main` bump MAJOR.

## 0.4.0 — 2026-11-25

Catalog visual-audit fixes from the BraisenlySwiftDemo live walk (`docs/audits/2026-11-13-catalog-visual-audit.md`).

### Fixed
- `BraisenlySplitView`: sidebar and detail columns fill their full height; solid themes paint the window toolbar band in the column background (F1, F2, F3).
- `BraisenlyStepperRow`: themed minus/plus buttons on both platforms, replacing the unthemed system stepper (F20).
- `BraisenlyToggleRow`: full-width row with trailing switch on macOS, matching iPad (F19).
- `BraisenlySegmentedControl`, `BraisenlyChipGroup`, `BraisenlyNavRow`: selected-state label contrast raised to ≥ 4.5:1 in Light and Dark (F17).
- `BraisenlyCapsuleModifier` (solid themes): hairline stroke and faint shadow (opacity ≤ 0.08, radius ≤ 4) instead of heavy grey drop shadows (F18).
- `BraisenlyParameterSliderRow`: no tick dots on fine steps; the thumb keeps a continuous position so keyboard increments are not rounded away (F24).
- `BraisenlyTextFieldRow` caption and `BraisenlyPropertyTable` key/value text: never below the theme `metadata` size or 11 pt (F23).
- `BraisenlyCodeBlockCard`: horizontal scroller hidden; long lines still scroll (F20).
- `BraisenlyMobileWorkspaceView`: follows the environment theme unless `initialTheme` is passed (F4).
- `BraisenlyRegularWorkspace`: system sidebar toggle removed from the embedded split view (F8).
- `BraisenlyColorSwatch`: name stacks under the circle on one middle-truncated line (F10).
- `BraisenlyHighlightedText`: single wrapped `Text` with inline rounded match highlights; no detached fragments (F11).

### Added
- `docs/audits/2026-11-13-catalog-visual-audit.md`: audit brief and findings F1–F24.

## 0.3.0 — 2026-11-12

Narrow-sidebar layout fixes found live in the BraisenlySwiftDemo catalog.

### Fixed
- `BraisenlyThemeSwitcher` (`.row`) no longer wraps theme names one character per line in a narrow sidebar; it falls back to icon-only pills (accessibility labels kept) when the labelled row does not fit.
- `BraisenlySidebarSearchHeader` no longer draws a stray "Aa" over the search field; the field is single-line.
- `BraisenlySplitView` gives the sidebar a 260–420 pt column width (ideal 300).

## 0.2.0 — 2026-11-12

Environment-driven theming, Liquid Glass default theme, and catalog primitives.

### Breaking
- Raised the platform floor to iOS 26 and macOS 26.
- Removed `BraisenlyTheme` and `BraisenlyThemeToggle`. Use `BraisenlyThemeDefinition`, `BraisenlyThemes`, `View.braisenlyTheme(_:)` and `BraisenlyThemeSwitcher`.
- Workspace, document and AI chat views take `Binding<BraisenlyThemeDefinition.ID>` (or an initial theme id) instead of `BraisenlyTheme`.
- Init parameters that defaulted to static tokens are now optional overrides (`Color? = nil`, `CGFloat? = nil`, `Font? = nil`) resolved against the environment theme.
- `BraisenlyMobileWorkspaceView`, `AIChatView` and `AIChatWorkspaceView` start in Liquid Glass (previously Solarized Dark via `initialTheme: .dark`).
- Typography uses Dynamic Type text styles; text sizes differ from the old fixed sizes, notably on macOS.

### Added
- `BraisenlyThemeDefinition` with color, typography and metric tokens, a spacing and radius scale (`BraisenlyStep`), and a glass or solid surface style; `EnvironmentValues.braisenlyTheme` (default Liquid Glass).
- Built-in themes `liquidGlass` (default), `solarizedLight`, `solarizedDark`.
- `BraisenlyThemeSwitcher` (row and cycle styles).
- Layout wrappers: `BraisenlyVStack`, `BraisenlyHStack`, `BraisenlyZStack`, `BraisenlyScroll`, `BraisenlySpacer`, `BraisenlyDivider`, `BraisenlyText`, `BraisenlyIcon`, `BraisenlyGrid`, `BraisenlySplitView`, `View.braisenlyPadding(_:_:)`.
- Controls: `BraisenlySectionHeader`, `BraisenlyNavRow`, `BraisenlySegmentedControl`, `BraisenlyToggleRow`, `BraisenlyStepperRow`, `BraisenlyTextFieldRow`, `BraisenlyChipGroup`, `BraisenlyColorSwatch`, `BraisenlyPropertyTable`, `BraisenlyEmptyState`, `BraisenlyButton`.
- `View.braisenlySheetBackground()`; `braisenlyCard`/`braisenlyCapsule` take a `BraisenlySurfaceRole`.
- Guard tests: components read no static tokens or literal metrics, and the public API is identical on iOS and macOS (no public declarations behind `#if os`/`#if canImport`).

### Changed
- Every component reads tokens from the environment theme; Liquid Glass is applied only to control and navigation surfaces.
- `BraisenlyDS` remains as the static Solarized source values; components no longer read it.

## 0.1.0 — 2026-11-08

Baseline merge of `ai-chat-components` into `development`.

### Added
- Adaptive Solarized Light/Dark design tokens (`BraisenlyDesignSystem`, `BraisenlyAdaptiveColor`) and `BraisenlyTheme` toggle.
- 47 public SwiftUI components split one-per-file: buttons and pills, indicators, fields, cards, rows and groups, sidebar, document, and compact/regular/mobile workspaces. `BraisenlyPlatform` density (iPhone/iPad/mac).
- `BraisenlyAI` product: single-responsibility AI chat primitives and compound workspace views; multi-provider chat clients (Anthropic, OpenAI-compatible, Apple Foundation Models, on-device MLX).
- Open-weight MLX model profiles (LFM3, LFM3-Omni, Qwen3.5, Gemma4) with on-device MLX Swift LM inference and a HuggingFace weight downloader.

### Changed
- Package now exposes two products, `BraisenlySwiftUI` and `BraisenlyAI`; depends on mlx-swift and mlx-swift-lm for the AI product only.
