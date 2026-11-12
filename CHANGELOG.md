# Changelog

All notable changes to BraisenlySwiftUI. Versions follow MAJOR.MINOR.PATCH; merges into `development` bump MINOR, promotions to `main` bump MAJOR.

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
