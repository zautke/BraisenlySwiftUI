# Changelog

All notable changes to BraisenlySwiftUI. Versions follow MAJOR.MINOR.PATCH; merges into `development` bump MINOR, promotions to `main` bump MAJOR.

## 0.1.0 — 2026-11-08

Baseline merge of `ai-chat-components` into `development`.

### Added
- Adaptive Solarized Light/Dark design tokens (`BraisenlyDesignSystem`, `BraisenlyAdaptiveColor`) and `BraisenlyTheme` toggle.
- 47 public SwiftUI components split one-per-file: buttons and pills, indicators, fields, cards, rows and groups, sidebar, document, and compact/regular/mobile workspaces. `BraisenlyPlatform` density (iPhone/iPad/mac).
- `BraisenlyAI` product: single-responsibility AI chat primitives and compound workspace views; multi-provider chat clients (Anthropic, OpenAI-compatible, Apple Foundation Models, on-device MLX).
- Open-weight MLX model profiles (LFM3, LFM3-Omni, Qwen3.5, Gemma4) with on-device MLX Swift LM inference and a HuggingFace weight downloader.

### Changed
- Package now exposes two products, `BraisenlySwiftUI` and `BraisenlyAI`; depends on mlx-swift and mlx-swift-lm for the AI product only.
