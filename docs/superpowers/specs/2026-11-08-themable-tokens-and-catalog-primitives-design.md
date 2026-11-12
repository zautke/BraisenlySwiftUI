# Themable tokens and catalog primitives — design spec

- Date: 2026-11-08
- Author: Architect (package side), team BSD-001 "Catalog Build Wing"
- Repo / branch: `zautke/BraisenlySwiftUI`, worktree `/Volumes/MACDEV/BraisenlySwiftUI-catalog`, branch `feat/themable-tokens-and-catalog-primitives` (tip `62c2480`, 0.1.0 baseline)
- Binding inputs: coordinator plan `use-superpowers-and-caveman-prancy-matsumoto.md` (U-1..U-13, D-1..D-3), inventory `BraisenlySwiftDemo-scaffold/docs/catalog-inventory.md`
- Release target: **0.2.0** (MINOR bump into `development`; breaking change accepted under U-5)
- Implementation plan: `docs/superpowers/plans/2026-11-08-themable-tokens-and-catalog-primitives.md`

## 1. Intent

The package's tokens are static (`BraisenlyDS.Colors.x`), so nothing that uses them can be re-themed at runtime, and every font is a fixed point size, so nothing supports Dynamic Type. The demo catalog (`BraisenlySwiftDemo`) must be built only from package components (U-3) and must switch between three themes live (U-7). That requires:

1. Tokens become values carried in the SwiftUI environment (`BraisenlyThemeDefinition`), with Liquid Glass as the default theme and Solarized Light/Dark as opt-in themes.
2. Every component reads the environment theme instead of static tokens.
3. The package gains the layout wrappers (D-2) and controls (D-3) the catalog shell needs, so the demo needs no bare SwiftUI.

## 2. Goals, non-goals, anti-goals

**Goals**
- G1. One environment-driven theme model; three built-in themes; one modifier to apply a theme.
- G2. All 36 core component views and the 14 `BraisenlyAI` views read tokens from `@Environment(\.braisenlyTheme)`. Zero static `BraisenlyDS.*` references in component code, enforced by a test.
- G3. Fixed-size fonts replaced by text-style typography tokens (Dynamic Type on iOS/iPadOS).
- G4. The ~100 hardcoded paddings, 51 hardcoded stack spacings and the untokenized radii replaced by a spacing scale and a radius scale.
- G5. Glass vs solid surfaces decided in one place (surface modifiers), with glass used only on the controls/navigation layer.
- G6. Layout wrappers, 10 controls, `BraisenlyButton` and `BraisenlyThemeSwitcher` added, each with a Swift Testing test.
- G7. Package floor iOS 26 / macOS 26; no `#available` forks for glass.

**Non-goals**
- Demo app code, catalog registry, knobs, scripts (separate spec in the demo repo).
- AI catalog entries (U-1). AI views are migrated to the theme only because removing `BraisenlyTheme` breaks them and leaving them on static Solarized tokens would make them ignore the active theme.
- Snapshot testing (U-11). Rendering is checked by `ImageRenderer` smoke tests and the live battery.
- Re-layout or redesign of existing components beyond token substitution.
- Changing the `BraisenlyAI` model layer, MLX dependencies, or the FoundationModels `@available` gates in `Sources/AI/Models`.

**Anti-goals (must not happen)**
- Glass on content containers (cards, bubbles, banners, code blocks, sheet content): HIG says glass is a controls/navigation-layer effect.
- Nested `GlassEffectContainer`s.
- A custom layout engine. Wrappers are thin one-liners over SwiftUI stacks.
- `@unchecked Sendable`, `nonisolated(unsafe)`, or `#available` forks for glass.
- Hardcoded host/config duplication: token values live in exactly one place (`BraisenlyTokens.swift` / `BraisenlyThemes.swift`).

## 3. Constraints

| Constraint | Value |
|---|---|
| Platform floor | `.iOS(.v26)`, `.macOS(.v26)` in `Package.swift` (U-6). Toolchain on largo: Xcode 27.2, Swift 6.4.2, SDK macosx27.2 / iphoneos27.2. |
| Language | `swift-tools-version: 6.4`, Swift 6 language mode, `.enableUpcomingFeature("ApproachableConcurrency")` on every target (unchanged). |
| Concurrency | All token types are value types conforming to `Sendable` and `Equatable`. Verified in the macOS 27.2 SDK: `public struct Glass : Equatable, Sendable` (SwiftUICore.swiftinterface:7422); `Color`, `Font`, `ColorScheme`, `CGFloat` are `Sendable`. `@Entry` macro present (SwiftUICore.swiftinterface:3627). |
| Liquid Glass | `glassEffect(_:in:)`, `Glass` (`.regular/.clear/.identity/.tint(_:)/.interactive(_:)`), `GlassEffectContainer(spacing:)`. Glass only on control/chrome surfaces. Apply `.glassEffect` after layout modifiers. `.interactive()` only on tappable surfaces. |
| Accessibility | Reduce Transparency: rely on the system's glass adaptation (glass becomes more opaque); no custom fallback. Reduce Motion: every theme-change animation and every `withAnimation` added by this work is skipped when `accessibilityReduceMotion` is true. Dynamic Type: all typography tokens are text-style based; icon sizes passed as `CGFloat` parameters scale via `@ScaledMetric`. |
| Platform-identical public API (U-16) | The public API surface of `BraisenlySwiftUI` is identical on iOS and macOS. No `public` type, member or extension may be declared inside an `#if os(…)` or `#if canImport(…)` region; platform differences live only inside bodies or internal helpers. This makes the macOS symbol graph authoritative for the demo's completeness test. Enforced by the `platformConditionalPublic` scan (§11.2). |
| Platform branching | Only the existing patterns: `#if canImport(UIKit)` / `#elseif canImport(AppKit)` for system colors, and runtime `BraisenlyPlatform` density. No `#available`. |
| Tests | Swift Testing only (`import Testing`, `@Test`, `#expect`, `#require`). Tests that render use `@MainActor`. |
| Commits | Conventional Commits with scopes, e.g. `feat(theme): …`, `refactor(tokens): …`. |

## 4. Theme model (D-1, exact)

All new theme files live in `Sources/BraisenlySwiftUI/Theme/`.

### 4.1 Scale step

```swift
public enum BraisenlyStep: String, CaseIterable, Sendable { case zero, xs, s, m, l, xl }

public struct BraisenlyScale: Sendable, Equatable {
    public var xs: CGFloat, s: CGFloat, m: CGFloat, l: CGFloat, xl: CGFloat
    public init(xs: CGFloat, s: CGFloat, m: CGFloat, l: CGFloat, xl: CGFloat)
    public subscript(_ step: BraisenlyStep) -> CGFloat { get }   // .zero -> 0
}
```

Values (both scales are the same in all three themes):

| step | spacing | radius |
|---|---|---|
| `.zero` | 0 | 0 |
| `.xs` | 4 | 4 |
| `.s` | 8 | 10 |
| `.m` | 12 | 14 |
| `.l` | 16 | 20 |
| `.xl` | 24 | 24 |

**Snapping rule for migration** (hardcoded value -> step). Spacing/padding: 1–5 → `.xs`; 6–10 → `.s`; 11–14 → `.m`; 15–20 → `.l`; 21–28 → `.xl`. Radius: 3–5 → `.xs`; 8–12 → `.s`; 13–16 → `.m`; 17–20 → `.l`; 21–26 → `.xl`. `spacing: 0` stays `0` (literal zero is allowed). Values above 28 (DocumentCanvas top 82/74 and bottom 110, SidebarDrawer bottom 104/126, DocumentCanvas horizontal 32) are layout offsets, not spacing: express them as sums of metric tokens (e.g. `theme.metrics.toolbarHeight + theme.metrics.spacing[.l]`) with a visual delta of at most 8 pt. HighlightedText's 1.5/0.5 insets become `theme.metrics.hairline * 3` / `theme.metrics.hairline`. Platform ternaries keep the ternary between two steps (`resolvedPlatform == .mac ? theme.metrics.spacing[.m] : theme.metrics.spacing[.l]`).

### 4.2 Token structs (`Theme/BraisenlyTokens.swift`)

```swift
public struct BraisenlyColorTokens: Sendable, Equatable {
    // Names identical to BraisenlyDS.Colors so migration is a mechanical rename.
    public var backgroundPrimary, backgroundDimmed, surfaceSheet, surfaceElevated,
               surfaceHighlight, surfaceSnippet, borderSubtle, divider, accentTeal,
               textPrimary, textBright, textSecondary, textDisabled,
               matchBackground, matchForeground: Color
    // New semantic tokens (replace Solarized.* and Color.black literals in components):
    public var danger, warning, success, scrim, shadow: Color
    public init(/* all 20, labelled, in the order above */)
    public static func solarized(_ scheme: ColorScheme) -> Self   // light/dark Solarized values
    public static var system: Self { get }                        // Liquid Glass palette
}

public struct BraisenlyTypographyTokens: Sendable, Equatable {
    public var documentTitle, vaultTitle, bodyReading, rowLabel, rowLabelMedium,
               snippetBody, metadata, badgeNumber, code, labelEmphasis, chipLabel,
               rowIcon, controlIcon, controlIconEmphasis: Font
    public init(/* all 14, labelled */)
    public static let standard: Self
}

public struct BraisenlyMetricTokens: Sendable, Equatable {
    public var spacing: BraisenlyScale
    public var radius: BraisenlyScale
    public var circleButtonSize: CGFloat    // 44
    public var toolbarHeight: CGFloat       // 54
    public var rowHeight: CGFloat           // 48
    public var sidebarWidthRatio: CGFloat   // 0.84
    public var hairline: CGFloat            // 0.5
    public var sheetCornerRadius: CGFloat   // 28 (was presentationCornerRadius(28))
    public var grabberSize: CGSize          // 46 x 5 (three duplicated sheet grabbers)
    public init(/* all, labelled */)
    public static let standard: Self
}
```

**Color values.** `solarized(.light)` takes the light hex of every adaptive pair in `BraisenlyDS.Colors`; `solarized(.dark)` the dark hex; `accentTeal` = cyan `0x2AA198`, `matchBackground` = orange `0xCB4B16`, `matchForeground` = base3 `0xFDF6E3`; `danger` = red `0xDC322F`, `warning` = orange `0xCB4B16`, `success` = green `0x859900`, `scrim` = black at 0.38, `shadow` = black at 0.35. The Solarized colors are fixed (non-adaptive) because those themes pin their color scheme. Build them from `BraisenlyRGB` (existing internal type) so the hex values are defined once.

`system` (Liquid Glass) uses platform semantic colors through a new internal helper `BraisenlySystemColor` (`Theme/BraisenlySystemColor.swift`, same `#if canImport(UIKit)` / `AppKit` pattern as `BraisenlyAdaptiveColor`):

| token | UIKit | AppKit |
|---|---|---|
| backgroundPrimary | `.systemBackground` | `.windowBackgroundColor` |
| backgroundDimmed | `.secondarySystemBackground` | `.underPageBackgroundColor` |
| surfaceSheet | `.secondarySystemBackground` | `.windowBackgroundColor` |
| surfaceElevated | `.secondarySystemBackground` | `.controlBackgroundColor` |
| surfaceHighlight | `.tertiarySystemFill` | `.unemphasizedSelectedContentBackgroundColor` |
| surfaceSnippet | `.tertiarySystemBackground` | `.controlBackgroundColor` |
| borderSubtle, divider | `.separator` | `.separatorColor` |
| textPrimary, textBright | `.label` | `.labelColor` |
| textSecondary | `.secondaryLabel` | `.secondaryLabelColor` |
| textDisabled | `.tertiaryLabel` | `.tertiaryLabelColor` |

`accentTeal`, `matchBackground`, `matchForeground`, `danger`, `warning`, `success`, `scrim`, `shadow` keep the Solarized brand values in the Liquid Glass theme (brand accent survives the theme switch).

**Typography values (`standard`)** — every token is `Font.system(_ style:design:weight:)`, so it scales with Dynamic Type on iOS/iPadOS:

| token | value | replaces |
|---|---|---|
| documentTitle | `.system(.title, weight: .bold)` | `Typography.documentTitle` (30 bold) |
| vaultTitle | `.system(.title3, weight: .bold)` | `vaultTitle` (20 bold) |
| bodyReading | `.system(.body)` | `bodyReading` (17.5) |
| rowLabel | `.system(.body)` | `rowLabel` (16.5) |
| rowLabelMedium | `.system(.body, weight: .medium)` | `rowLabelMedium` |
| snippetBody | `.system(.subheadline)` | `snippetBody` (14) |
| metadata | `.system(.footnote)` | `metadata` (13.5) |
| badgeNumber | `.system(.caption, design: .rounded, weight: .bold)` | `badgeNumber` (12) |
| code | `.system(.footnote, design: .monospaced)` | CodeBlockCard:42 (13.5 mono) |
| labelEmphasis | `.system(.footnote, weight: .semibold)` | SuggestionCard:28 (13 semibold) |
| chipLabel | `.system(.caption2, weight: .semibold)` | ModelPill:32,:40 (11/10), CitationPill:33 (11) |
| rowIcon | `.system(.subheadline, weight: .medium)` | ConversationRow:37 (14 medium) |
| controlIcon | `.system(.title3, weight: .medium)` | DualActionPill:28, ToolbarIconButton:24, ThemeToggle:19 (18 medium) |
| controlIconEmphasis | `.system(.callout, weight: .bold)` | SendStopButton:28 (16 bold) |

AvatarBadge:29 and CircleIconButton:30 take `iconSize: CGFloat` from their init; they keep the parameter and render `.font(.system(size: iconSize * iconScale, weight: …))` with `@ScaledMetric(relativeTo: .body) private var iconScale: CGFloat = 1`.

Known effect (Architect's call): on macOS, text styles resolve to macOS sizes (`.body` is 13 pt), so macOS text becomes denser than the old fixed 16.5–17.5 pt. This matches the macOS HIG and the existing `BraisenlyPlatform.mac` density.

### 4.3 Surface style and role (`Theme/BraisenlyThemeDefinition.swift`)

```swift
public enum BraisenlySurfaceStyle: Sendable, Equatable {
    case glass(Glass)
    case solid
    /// nil = draw the solid fill. Glass only for non-content roles;
    /// `.control` adds `.interactive()`.
    public func glass(for role: BraisenlySurfaceRole) -> Glass?
}

public enum BraisenlySurfaceRole: Sendable, Equatable {
    case content   // cards, bubbles, banners, code, sheet content: always solid
    case control   // tappable surface: glass + interactive
    case chrome    // non-tappable floating navigation/toolbar/popover surface: glass, not interactive
}
```

`glass(for:)` truth table: `.solid` → nil for every role; `.glass(g)` → `.content` nil, `.control` `g.interactive()`, `.chrome` `g`.

### 4.4 Theme definition, themes, environment, modifier

```swift
public struct BraisenlyThemeDefinition: Sendable, Identifiable, Equatable {
    public var id: String
    public var name: String
    public var symbolName: String
    public var colorScheme: ColorScheme?        // nil = follow system
    public var colors: BraisenlyColorTokens
    public var typography: BraisenlyTypographyTokens
    public var metrics: BraisenlyMetricTokens
    public var surface: BraisenlySurfaceStyle
    public init(id: String, name: String, symbolName: String, colorScheme: ColorScheme?,
                colors: BraisenlyColorTokens, typography: BraisenlyTypographyTokens = .standard,
                metrics: BraisenlyMetricTokens = .standard, surface: BraisenlySurfaceStyle)
}

public extension BraisenlyThemeDefinition {
    static var liquidGlass: Self { get }      // forwards to BraisenlyThemes
    static var solarizedLight: Self { get }
    static var solarizedDark: Self { get }
}

public enum BraisenlyThemes {                     // Theme/BraisenlyThemes.swift
    public static let liquidGlass: BraisenlyThemeDefinition
    public static let solarizedLight: BraisenlyThemeDefinition
    public static let solarizedDark: BraisenlyThemeDefinition
    public static let all: [BraisenlyThemeDefinition]   // [liquidGlass, solarizedLight, solarizedDark]
    /// Unknown id falls back to `liquidGlass` (never traps).
    public static func theme(withID id: BraisenlyThemeDefinition.ID,
                             in themes: [BraisenlyThemeDefinition] = all) -> BraisenlyThemeDefinition
    /// Wraps around; unknown id returns themes.first's id (or the input id when themes is empty).
    public static func nextID(after id: BraisenlyThemeDefinition.ID,
                              in themes: [BraisenlyThemeDefinition] = all) -> BraisenlyThemeDefinition.ID
}

extension EnvironmentValues {
    @Entry public var braisenlyTheme: BraisenlyThemeDefinition = .liquidGlass
}

public extension View {
    /// Sets the environment theme, applies `preferredColorScheme(theme.colorScheme)`
    /// (nil = no preference) and `.tint(theme.colors.accentTeal)` so system controls follow the theme.
    func braisenlyTheme(_ theme: BraisenlyThemeDefinition) -> some View
}
```

| theme | id | name | symbolName | colorScheme | colors | surface |
|---|---|---|---|---|---|---|
| liquidGlass | `"liquidGlass"` | `"Liquid Glass"` | `"sparkles"` | `nil` | `.system` | `.glass(.regular)` |
| solarizedLight | `"solarizedLight"` | `"Solarized Light"` | `"sun.max.fill"` | `.light` | `.solarized(.light)` | `.solid` |
| solarizedDark | `"solarizedDark"` | `"Solarized Dark"` | `"moon.stars.fill"` | `.dark` | `.solarized(.dark)` | `.solid` |

`theme(withID:in:)` searches `themes` first and falls back to `BraisenlyThemes.liquidGlass`, so a custom theme list works and an unknown id never crashes.

`preferredColorScheme` acts on the whole presentation (window / sheet). That is the intended behavior: the catalog applies the theme at its root.

**`BraisenlyDS` stays** as the public static Solarized source (U-5): `Solarized`, `Colors` (adaptive), `Typography` (fixed sizes), `Metrics` keep their current API and values. Components no longer read it; consumers may. Doc comment on `BraisenlyDesignSystem` changes to say so.

## 5. Surface modifiers: glass vs solid (Task 2)

Signatures (source-compatible with existing call sites because explicit `Color`/`CGFloat` arguments promote to optionals):

```swift
public struct BraisenlyCardModifier: ViewModifier {
    public let cornerRadius: CGFloat?
    public let fill: Color?
    public let role: BraisenlySurfaceRole
    public init(cornerRadius: CGFloat? = nil, fill: Color? = nil, role: BraisenlySurfaceRole = .content)
}
public struct BraisenlyCapsuleModifier: ViewModifier {
    public let fill: Color?
    public let role: BraisenlySurfaceRole
    public init(fill: Color? = nil, role: BraisenlySurfaceRole = .control)
}
public extension View {
    func braisenlyCard(cornerRadius: CGFloat? = nil, fill: Color? = nil,
                       role: BraisenlySurfaceRole = .content) -> some View
    func braisenlyCapsule(fill: Color? = nil, role: BraisenlySurfaceRole = .control) -> some View
    /// Sheet presentation styling: presentationCornerRadius(theme.metrics.sheetCornerRadius);
    /// solid -> presentationBackground(theme.colors.surfaceSheet); glass -> system glass sheet (no background).
    func braisenlySheetBackground() -> some View
}

/// Internal. The single owner of GlassEffectContainer.
struct BraisenlyGlassGroup<Content: View>: View {
    init(spacing: BraisenlyStep = .s, @ViewBuilder content: () -> Content)
}
extension EnvironmentValues { @Entry var braisenlyIsInGlassGroup: Bool = false }   // internal
```

Behavior:

| modifier | theme surface `.solid` | theme surface `.glass(g)`, role `.content` | `.glass(g)`, role `.control` / `.chrome` |
|---|---|---|---|
| `braisenlyCard` | rounded rect (radius `cornerRadius ?? theme.metrics.radius[.l]`) filled `fill ?? theme.colors.surfaceElevated`, stroke `borderSubtle.opacity(0.6)` width `hairline * 1.6` (today: 0.8) | same as solid (content never gets glass) | `.glassEffect(g[.interactive()], in: RoundedRectangle(cornerRadius:, style: .continuous))`; `fill` ignored; no stroke |
| `braisenlyCapsule` | capsule fill `(fill ?? surfaceElevated).opacity(0.94)`, stroke `borderSubtle`, shadow `theme.colors.shadow` radius 12 y 6 | same as solid | `.glassEffect(…, in: Capsule(style: .continuous))`; no fill, stroke or shadow |

`fill` is the solid-mode fill only. Glass is the surface in glass mode; tinting is not exposed in 0.2.0 (YAGNI).

`BraisenlyGlassGroup`: if the theme surface is `.solid`, or `braisenlyIsInGlassGroup` is already true, it renders `content` unchanged; otherwise it renders `GlassEffectContainer(spacing: theme.metrics.spacing[spacing]) { content }` and sets `braisenlyIsInGlassGroup = true` for descendants. This makes "never nest a container" structural rather than a convention.

### 5.1 Role per existing call site

| call site | modifier | role |
|---|---|---|
| CircleIconButton, DualActionPill, MessageActionPill, CitationPill (Link), SidebarFooter (mode button), AIConversationSidebar:58 (New Chat button) | capsule | `.control` (default) |
| SidebarSearchHeader (text field) | capsule | `.chrome` (glass without `.interactive()`: a text field must not flex on touch; Architect's call) |
| ModelPill | capsule | `action == nil ? .chrome : .control` |
| BottomToolbar (bar background) | capsule | `.chrome` |
| SidebarContextPopover | card | `.chrome` (floating menu); its `.shadow` becomes solid-only via `theme.colors.shadow` |
| PromptField | card | `.chrome` (floating composer field; glass, not interactive, because it is a text field; Architect's call) |
| ChatBubbleSurface, ActionGroup, CodeBlockCard, StatusCard, DocumentActionSheet, SearchSnippetCard, ParameterSliderRow, KeyEntryField, BannerCard, SuggestionCard, AIConversationActionSheet | card | `.content` (default) |
| MobileWorkspaceView `.sheet`, AIChatWorkspaceView `.sheet` ×2 | `braisenlySheetBackground()` replaces `.presentationCornerRadius(28)` + `.presentationBackground(BraisenlyDS.Colors.surfaceSheet)` | — |

Sheet content additionally re-applies `.braisenlyTheme(theme)` inside the sheet closure (one line; removes any doubt about environment propagation across the presentation boundary).

### 5.2 GlassEffectContainer owners

Rule: a component owns a container (via `BraisenlyGlassGroup`) iff it lays out two or more glass-surfaced children as one visual group. Leaf components never create one; `BraisenlyGlassGroup` collapses accidental nesting.

| owner | why |
|---|---|
| BraisenlyBottomToolbar | toolbar capsule + its glass children |
| BraisenlyDocumentChrome | row of CircleIconButtons + ThemeSwitcher + DualActionPill |
| BraisenlySidebarDrawer | search header capsule + footer capsule |
| BraisenlyThemeSwitcher (`.row`) | one capsule per theme |
| BraisenlySegmentedControl | one capsule per option |
| BraisenlyChipGroup | one capsule per chip |

`BraisenlyGlassGroup` is internal to the `BraisenlySwiftUI` module, so AI views (AIComposer, AIChatHeader) own no container. Their leaves render standalone glass, which costs a little blending between adjacent AI controls and carries no nesting risk (Architect's call).

Leaves (no container): CircleIconButton, ToolbarIconButton, SendStopButton, DualActionPill, MessageActionPill, ModelPill, CitationPill, TabCounterBadge, PromptField, SidebarSearchHeader, SidebarFooter, SidebarContextPopover, BraisenlyButton, ThemeSwitcher `.cycle`.

## 6. Migration rules for existing components

1. Add `@Environment(\.braisenlyTheme) private var theme` to every view that used a token; replace `BraisenlyDS.Colors.x` → `theme.colors.x`, `BraisenlyDS.Typography.x` → `theme.typography.x`, `BraisenlyDS.Metrics.cardRadius` → `theme.metrics.radius[.l]`, `popoverRadius` → `radius[.xl]`, `snippetRadius` → `radius[.s]`, other `Metrics.x` → `theme.metrics.x`, `Solarized.red` → `colors.danger`, `Solarized.orange` → `colors.warning`, `Solarized.green` → `colors.success`, `Color.black.opacity(0.38)` → `colors.scrim`, `.black.opacity(0.35/0.45)` shadows → `colors.shadow`.
2. Fixed fonts → typography tokens per §4.2 table.
3. Numeric `.padding`, `spacing:` (non-zero), `cornerRadius:` → scale steps per §4.1 snapping rule. Sheet grabber `Capsule().frame(width: 46, height: 5)` → `theme.metrics.grabberSize`.
4. **Public init parameters that default to a static token** become optional overrides with `nil` default, resolved against the theme in `body`:

| type | parameter: old → new | resolved as |
|---|---|---|
| BraisenlyAvatarBadge | `foregroundColor/backgroundColor/borderColor: Color = …` → `Color? = nil` | `accentTeal` / `surfaceElevated` / `borderSubtle` |
| BraisenlyBannerCard | `iconColor: Color = Solarized.red` → `Color? = nil` | `danger` |
| BraisenlyChatBubbleSurface | `fill`, `foregroundColor: Color` → `Color? = nil`; `cornerRadius: CGFloat = 18` → `CGFloat? = nil` | `surfaceElevated`, `textPrimary`, `radius[.l]` |
| BraisenlyHighlightedText | `font: Font = Typography.rowLabel` → `Font? = nil`; `baseColor` → `Color? = nil` | `typography.rowLabel`, `textPrimary` |
| BraisenlyPromptField | `cornerRadius: CGFloat = 18` → `CGFloat? = nil`; `fill` → `Color? = nil` | `radius[.l]`, `surfaceElevated` |
| BraisenlyStatusCard | `iconColor` → `Color? = nil` | `accentTeal` |
| BraisenlyCardModifier / CapsuleModifier | see §5 | see §5 |

Stored public properties keep their names and take the optional type. Existing call sites that pass a value still compile (`Color` → `Color?` promotion). Existing test `bubble.cornerRadius == 20` still compiles and passes.

5. Theme bindings (because `BraisenlyTheme` is removed):

| type | old | new |
|---|---|---|
| BraisenlyDocumentChrome | `theme: Binding<BraisenlyTheme> = .constant(.dark)` | `theme: Binding<BraisenlyThemeDefinition.ID> = .constant(BraisenlyThemes.liquidGlass.id)`; renders `BraisenlyThemeSwitcher(selection: theme, style: .cycle, platform:)` |
| BraisenlyDocumentCanvas | same | same, passes through to chrome |
| BraisenlyCompactWorkspace, BraisenlyRegularWorkspace | `theme: Binding<BraisenlyTheme>` | `theme: Binding<BraisenlyThemeDefinition.ID>` |
| BraisenlyMobileWorkspaceView | `initialTheme: BraisenlyTheme = .dark` | `initialTheme: BraisenlyThemeDefinition.ID = BraisenlyThemes.liquidGlass.id`; owns `@State themeID`; applies `.braisenlyTheme(BraisenlyThemes.theme(withID: themeID))` |
| AIChatHeader | `theme: Binding<BraisenlyTheme>` | `theme: Binding<BraisenlyThemeDefinition.ID>`; uses ThemeSwitcher `.cycle` |
| AIChatView | `initialTheme: BraisenlyTheme = .dark`, `theme: Binding<BraisenlyTheme>? = nil` | `initialTheme: BraisenlyThemeDefinition.ID = BraisenlyThemes.liquidGlass.id`, `theme: Binding<BraisenlyThemeDefinition.ID>? = nil`; applies the theme like MobileWorkspaceView |
| AIChatWorkspaceView | `initialTheme: BraisenlyTheme = .dark` | `initialTheme: BraisenlyThemeDefinition.ID = BraisenlyThemes.liquidGlass.id`; applies the theme |

Views that only receive a binding do not apply the theme; the view that owns the state (`MobileWorkspaceView`, `AIChatView` when unbound, `AIChatWorkspaceView`, or the consumer app) applies `.braisenlyTheme(_:)`. Theme ids resolve against `BraisenlyThemes.all` (custom theme lists are supported by `BraisenlyThemeSwitcher` and `BraisenlyThemes.theme(withID:in:)`, not by the workspace views; documented limitation).

6. **Density vs metrics.** `BraisenlyPlatform` keeps owning density-dependent sizes: wherever a component already uses `platform.resolved(…).rowHeight` / `.controlSize` / `.contentMaxWidth`, it keeps doing so. `theme.metrics.rowHeight`, `circleButtonSize`, `toolbarHeight`, `sidebarWidthRatio` replace only the sites that read `BraisenlyDS.Metrics.*` today (KeyEntryField, BottomToolbar, CompactWorkspace, AIChatWorkspaceView). New controls (NavRow, ThemeSwitcher `.cycle`) use `BraisenlyPlatform` (Architect's call).
7. **Scope list.** The 36 core view files: ActionGroup, ActionRow, AvatarBadge, BannerCard, BottomToolbar, ChatBubbleSurface, CircleIconButton, CitationPill, CodeBlockCard, CompactWorkspace, ConversationRow, DocumentActionSheet, DocumentCanvas, DocumentChrome, DualActionPill, ExpandableSearchResult, HighlightedText, KeyEntryField, MessageActionPill, MobileWorkspaceView, ModelPill, ParameterSliderRow, PromptField, PulseIndicator, RegularWorkspace, SearchMetadataRow, SearchSnippetCard, SendStopButton, SidebarContextPopover, SidebarDrawer, SidebarFooter, SidebarSearchHeader, StatusCard, SuggestionCard, TabCounterBadge, ToolbarIconButton (all `Sources/BraisenlySwiftUI/Braisenly<Name>.swift`). Not migrated as views: ActionItem, SidebarMode, HighlightedTextSegment, Platform (data types), AdaptiveColor and DesignSystem (token sources), Card/CapsuleModifier (Task 2), Theme and ThemeToggle (deleted). The 14 AI views are every file in `Sources/AI/UI/`.
8. `.frame(width:/height:)` literals (icon columns, hairline dividers, max widths) are out of scope except the grabber; they are layout, not tokens.

## 7. Removals (breaking, U-5)

Deleted after every caller has moved: `Sources/BraisenlySwiftUI/BraisenlyTheme.swift` (`BraisenlyTheme` enum and `braisenlyTheme(_ theme: BraisenlyTheme)`), `Sources/BraisenlySwiftUI/BraisenlyThemeToggle.swift`, and test `themesToggleBidirectionally`. Until then the old and new `braisenlyTheme(_:)` overloads coexist (different parameter types, no ambiguity: the new type's static members are `.liquidGlass/.solarizedLight/.solarizedDark`, the old enum's are `.light/.dark`), so every task leaves the package compiling.

## 8. Layout wrappers (D-2) — `Sources/BraisenlySwiftUI/Layout/`, one type per file

```swift
public struct BraisenlyVStack<Content: View>: View {
    public init(alignment: HorizontalAlignment = .center, spacing: BraisenlyStep = .m,
                @ViewBuilder content: () -> Content)
}
public struct BraisenlyHStack<Content: View>: View {
    public init(alignment: VerticalAlignment = .center, spacing: BraisenlyStep = .m,
                @ViewBuilder content: () -> Content)
}
public struct BraisenlyZStack<Content: View>: View {
    public init(alignment: Alignment = .center, @ViewBuilder content: () -> Content)
}
public struct BraisenlySpacer: View {
    public init(minLength: BraisenlyStep? = nil)
}
public struct BraisenlyDivider: View {                 // Divider tinted theme.colors.divider
    public init()
}
public extension View {
    func braisenlyPadding(_ edges: Edge.Set = .all, _ step: BraisenlyStep = .m) -> some View
}
public struct BraisenlyScroll<Content: View>: View {
    public init(_ axes: Axis.Set = .vertical, showsIndicators: Bool = true,
                @ViewBuilder content: () -> Content)
}
public struct BraisenlyGrid<Content: View>: View {     // LazyVGrid, adaptive columns
    public init(minimumColumnWidth: CGFloat = 160, spacing: BraisenlyStep = .m,
                @ViewBuilder content: () -> Content)
}
public struct BraisenlySplitView<Sidebar: View, Detail: View>: View {
    public init(columnVisibility: Binding<NavigationSplitViewVisibility>? = nil,
                preferredCompactColumn: Binding<NavigationSplitViewColumn>? = nil,
                extendsDetailBackground: Bool = false,
                @ViewBuilder sidebar: () -> Sidebar,
                @ViewBuilder detail: () -> Detail)
}

public enum BraisenlyTextStyle: String, CaseIterable, Sendable {
    case documentTitle, vaultTitle, bodyReading, rowLabel, rowLabelMedium, snippetBody,
         metadata, badgeNumber, code, labelEmphasis, chipLabel
    public func font(in typography: BraisenlyTypographyTokens) -> Font
}
public enum BraisenlyTone: String, CaseIterable, Sendable {
    case primary, bright, secondary, disabled, accent, danger, warning, success
    public func color(in colors: BraisenlyColorTokens) -> Color
}
public struct BraisenlyText: View {
    public init(_ key: LocalizedStringKey, style: BraisenlyTextStyle = .rowLabel, tone: BraisenlyTone = .primary)
    @_disfavoredOverload
    public init<S: StringProtocol>(_ content: S, style: BraisenlyTextStyle = .rowLabel, tone: BraisenlyTone = .primary)
}
public enum BraisenlyIconSize: String, CaseIterable, Sendable {
    case small, medium, large      // typography.chipLabel / rowIcon / controlIcon
}
public struct BraisenlyIcon: View {
    public init(systemName: String, size: BraisenlyIconSize = .medium, tone: BraisenlyTone = .primary)
}
```

Behavior notes:
- Stacks resolve `spacing` as `theme.metrics.spacing[spacing]`. `BraisenlySpacer(minLength: nil)` = `Spacer()`.
- `BraisenlyText`/`BraisenlyIcon` are decorative/content text; icons are `.accessibilityHidden(true)` only when the caller pairs them with text (callers decide; the wrapper does not hide them).
- `BraisenlySplitView` wraps `NavigationSplitView`. Glass theme: system defaults (iOS 26 floating glass sidebar). Solid theme: sidebar `.background(theme.colors.backgroundDimmed)` and detail `.background(theme.colors.backgroundPrimary)` with `.scrollContentBackground(.hidden)`. `preferredCompactColumn` lets the catalog push the detail on iPhone when a `BraisenlyNavRow` (a button, not a `List` selection) is tapped. `extendsDetailBackground: true` applies `.backgroundExtensionEffect()` to the detail (hero/media content only).

## 9. Controls (D-3) — `Sources/BraisenlySwiftUI/Controls/`, one type per file

```swift
public struct BraisenlySectionHeader: View {
    public init(_ title: String, systemImage: String? = nil, trailing: String? = nil)
}
public struct BraisenlyNavRow: View {
    public init(title: String, systemImage: String? = nil, badge: String? = nil,
                isSelected: Bool, platform: BraisenlyPlatform = .automatic,
                action: @escaping () -> Void)
}
public struct BraisenlySegmentedControl<Value: Hashable>: View {
    public init(selection: Binding<Value>, options: [Value], title: @escaping (Value) -> String,
                platform: BraisenlyPlatform = .automatic)
}
public struct BraisenlyToggleRow: View {
    public init(_ title: String, subtitle: String? = nil, isOn: Binding<Bool>)
}
public struct BraisenlyStepperRow: View {
    public init(_ title: String, value: Binding<Int>, in range: ClosedRange<Int>, step: Int = 1)
}
public struct BraisenlyTextFieldRow: View {
    public init(_ title: String, text: Binding<String>, prompt: String = "", axis: Axis = .horizontal)
}
public struct BraisenlyChipGroup<Value: Hashable>: View {
    public init(selection: Binding<Value>, options: [Value], title: @escaping (Value) -> String)
}
public struct BraisenlyColorSwatch: View {
    public init(color: Color, name: String, detail: String? = nil, isSelected: Bool = false,
                action: (() -> Void)? = nil)
}
public struct BraisenlyPropertyTable: View {
    public struct Row: Identifiable, Hashable, Sendable {
        public var key: String; public var value: String
        public var id: String { key }
        public init(key: String, value: String)
    }
    public init(rows: [Row])
}
public struct BraisenlyEmptyState: View {
    public init(title: String, message: String? = nil, systemImage: String = "square.dashed",
                actionTitle: String? = nil, action: (() -> Void)? = nil)
}
public enum BraisenlyButtonProminence: Sendable { case standard, prominent }
public struct BraisenlyButton: View {
    public init(_ title: String, systemImage: String? = nil,
                prominence: BraisenlyButtonProminence = .standard, action: @escaping () -> Void)
}
```

Behavior (each row is the acceptance contract for its task):

| control | rendering | accessibility |
|---|---|---|
| SectionHeader | `typography.metadata`, `textSecondary`, uppercase title, optional leading icon, optional trailing text; horizontal padding `.l`, top `.l`, bottom `.xs` | `.accessibilityAddTraits(.isHeader)` |
| NavRow | button, height `platform.resolved(…).rowHeight`, icon (`rowIcon`) + title (`rowLabel`) + spacer + optional badge capsule (`badgeNumber`, `surfaceHighlight` fill, solid, role `.content`); selected fill `surfaceHighlight` rounded `radius[.s]` | `.isSelected` trait when selected; badge read as value |
| SegmentedControl | `BraisenlyGlassGroup` > HStack spacing `.xs` of capsule buttons (`chipLabel`→ use `rowLabelMedium` for text); selected option: capsule role `.control` with `textBright` + `accentTeal`, unselected `.control` with `textSecondary`; reduce-motion gated `.snappy` animation | each option `.isSelected` when selected |
| ToggleRow | native `Toggle` (system glass knob on 26) with title (`rowLabel`) + subtitle (`metadata`, `textSecondary`), `.tint(accentTeal)`, card `.content` | native |
| StepperRow | native `Stepper` with title and current value (`rowLabelMedium`, monospaced digits), clamps to `range` | value announced by Stepper |
| TextFieldRow | title (`metadata`) above `TextField(prompt, text:, axis:)` (`rowLabel`), card `.content` radius `.m` | label = title |
| ChipGroup | `BraisenlyGlassGroup` > internal `BraisenlyFlowLayout` (custom `Layout`, wraps rows) of capsule chips (`chipLabel`), selected chip `accentTeal` text | `.isSelected` per chip |
| ColorSwatch | circle (`radius` n/a) filled `color`, stroke `borderSubtle`, size `metrics.circleButtonSize`; name (`metadata`) + detail (`code`); selected ring `accentTeal`; if `action` non-nil it is a button | label = name, value = detail |
| PropertyTable | card `.content`; one row per entry: key (`metadata`, `textSecondary`) leading, value (`code`, `textPrimary`) trailing, `BraisenlyDivider`-style separators between rows | each row combined (`.accessibilityElement(children: .combine)`) |
| EmptyState | centered icon (`.system(.largeTitle)` via typography? use `documentTitle` font for icon), title (`vaultTitle`), message (`snippetBody`, `textSecondary`), optional `BraisenlyButton` | combined |
| Button | one `Button` with a private `ButtonStyle` whose values follow the theme (deviation 11, §15): glass theme: interactive glass capsule, accent-tinted when prominent; solid: capsule (`.control` path → solid fill `surfaceElevated` / `accentTeal` for prominent, text `textBright` / `matchForeground`); label `rowLabelMedium`; min height `metrics.circleButtonSize` | native button |

`BraisenlyFlowLayout` (internal, `Controls/BraisenlyFlowLayout.swift`) exposes a pure, testable row-packing function:
```swift
struct BraisenlyFlowLayout: Layout {
    var spacing: CGFloat
    /// Greedy left-to-right packing; returns indices per row. A child wider than maxWidth gets its own row.
    static func rows(for sizes: [CGSize], maxWidth: CGFloat, spacing: CGFloat) -> [[Int]]
}
```

## 10. BraisenlyThemeSwitcher (`Sources/BraisenlySwiftUI/BraisenlyThemeSwitcher.swift`)

```swift
public enum BraisenlyThemeSwitcherStyle: Sendable, Equatable { case row, cycle }

public struct BraisenlyThemeSwitcher: View {
    public init(selection: Binding<BraisenlyThemeDefinition.ID>,
                themes: [BraisenlyThemeDefinition] = BraisenlyThemes.all,
                style: BraisenlyThemeSwitcherStyle = .row,
                platform: BraisenlyPlatform = .automatic)
}
```
- `.row`: `BraisenlyGlassGroup` > HStack of one capsule button per theme (icon `symbolName` + `name`, `chipLabel`); selected one `accentTeal`, `.isSelected` trait.
- `.cycle`: one circular capsule button showing the current theme's `symbolName` (`controlIcon`, size `platform.resolved(…).controlSize`, `.contentTransition(.symbolEffect(.replace.downUp))`); tap sets `selection = BraisenlyThemes.nextID(after:in:)`. Accessibility label "Theme", value = current theme name, hint "Switches to <next name>". Replaces `BraisenlyThemeToggle`.
- Selection changes are wrapped in `withAnimation(.snappy(duration: 0.35))` unless `accessibilityReduceMotion`.
- Unknown `selection` id: rendered as if `themes.first` were selected; tapping cycles from there. Never traps.

## 11. Tests strategy (Swift Testing)

| file | what it proves |
|---|---|
| `Tests/BraisenlySwiftUITests/Support/SourceScan.swift` | helper: `SourceScan.violations(in relativePaths: [String]) throws -> [String]` returns `"<file>:<line>: <pattern>"` for banned patterns (§11.1), resolving paths from `#filePath` to the package root |
| `ThemeResolutionTests.swift` | `BraisenlyThemes.all` ids are `["liquidGlass","solarizedLight","solarizedDark"]`, unique; `EnvironmentValues().braisenlyTheme == .liquidGlass`; `theme(withID:"nope")` is liquidGlass; `nextID` wraps; scales monotonic and `[.zero] == 0`; spacing values 4/8/12/16/24, radius 4/10/14/20/24; solarizedDark `backgroundPrimary == BraisenlyDS.Solarized.base03` and solarizedLight `backgroundPrimary == BraisenlyDS.Solarized.base3`; `colorScheme` nil/light/dark; surface glass/solid; `glass(for:)` truth table (Glass is Equatable) |
| `SurfaceModifierTests.swift` | `BraisenlyGlassGroup` and both modifiers render via `ImageRenderer` in all three themes; `BraisenlyCardModifier()` defaults (`cornerRadius == nil`, `role == .content`); capsule default role `.control` |
| `TokenMigration<Batch>Tests.swift` (one per batch) | `SourceScan.violations(in: <batch files>)` is empty; each migrated view renders (`ImageRenderer(...).cgImage != nil`) under each of `BraisenlyThemes.all` |
| one `<Component>Tests.swift` per new wrapper/control/switcher | stored configuration, pure helpers (`rows(for:)`, `nextID`, `BraisenlyTextStyle.font(in:)` maps every case to the matching token, `BraisenlyScale` subscript), render smoke in all three themes |
| `StaticTokenGuardTests.swift` (final task) | repo-wide: every `.swift` under `Sources/` except the exempt list has zero violations; every `.swift` under `Sources/BraisenlySwiftUI/` (no exemptions) has zero `platformConditionalPublic` violations (U-16) |
| `Tests/BraisenlyAITests/AITokenMigration<Batch>Tests.swift` | render smoke for AI views (needs the AI module); the static scan of AI files runs in the BraisenlySwiftUITests target (file scan needs no import) |

### 11.1 Banned patterns (regex, in `SourceScan.bannedPatterns`)

| id | regex | catches |
|---|---|---|
| staticToken | `BraisenlyDS\.\|BraisenlyDesignSystem\.` | static token reads |
| fixedFont | `\.font\(\.system\(size:\s*[0-9]` | fixed-size fonts with a literal |
| literalPadding | `\.padding\((\.[A-Za-z]+,\s*)?([1-9]\|0\.)` | `.padding(12)`, `.padding(.horizontal, 14)`, `.padding(0.5)`; a literal `.padding(0)` is allowed |
| ternaryPadding | `\.padding\([^)]*\?\s*[0-9.]+\s*:\s*[0-9.]+` | `.padding(.top, isMac ? 16 : 10)` |
| literalSpacing | `spacing:\s*[1-9]` | non-zero literal stack spacing |
| literalRadius | `cornerRadius:\s*[0-9]` | literal corner radii |
| colorLiteral | `Color\.(black\|white\|gray)\|\.black\.opacity` | scrims and shadows |

There are no per-line suppressions. A legitimate value that matches is expressed through a token (sub-scale values through `metrics.hairline`); the only escape hatch is the exempt list. Exempt files: everything under `Sources/BraisenlySwiftUI/Theme/`, `Sources/BraisenlySwiftUI/BraisenlyDesignSystem.swift`, `Sources/BraisenlySwiftUI/BraisenlyAdaptiveColor.swift`, and everything under `Sources/AI/Models/`.

Negative test (first-class, reported PASS when it fails as declared): `SourceScanTests.detectsEachBannedPattern` feeds one offending line per pattern through `SourceScan.violations(inSource:named:)` and expects exactly one violation per line.

### 11.2 Platform-conditional public declarations (U-16)

`SourceScan.platformConditionalPublicViolations(inSource:named:) -> [String]` walks the file line by line with a stack of `#if` frames:
- `#if <cond>` pushes a frame; the frame is *platform* when `<cond>` contains `os(` or `canImport(`.
- `#elseif <cond>` marks the top frame *platform* if `<cond>` contains `os(` or `canImport(` (an `#elseif`/`#else` branch of a platform frame stays platform).
- `#endif` pops.
- A line is a violation when any frame on the stack is *platform* and the line matches the declaration regex `^\s*(@[A-Za-z_]+(\([^)]*\))?\s+)*(nonisolated\s+)?public\s` (covers `public struct`, `public extension`, `    public init`, `@MainActor public func`).
- Violation format: `"<file>:<line>: platformConditionalPublic"`. `//` comment lines are skipped.

Scope: every `.swift` file under `Sources/BraisenlySwiftUI/`, **including** `Theme/`, `BraisenlyDesignSystem.swift` and `BraisenlyAdaptiveColor.swift` (the §11.1 exempt list does not apply). The `BraisenlyAI` module is out of scope. At 0.1.0 the existing `#if` sites (`BraisenlyPlatform.resolved` body, `BraisenlyAdaptiveColor` imports and internal helper) already comply. The new `Theme/BraisenlySystemColor.swift` must keep every declaration inside its `#if canImport` branches internal.

Negative tests (PASS = the declared violation is reported):
- `#if os(macOS)` / `public struct X {}` / `#endif` → exactly `["N.swift:2: platformConditionalPublic"]`
- `#if canImport(UIKit)` / `#elseif canImport(AppKit)` / `    public init() {}` / `#endif` → violation on line 3
- `#if canImport(UIKit)` / `#else` / `@MainActor public func f() {}` / `#endif` → violation on line 3
- nested: `#if DEBUG` / `#if os(iOS)` / `public extension View {}` / `#endif` / `#endif` → violation on line 3

Positive tests (no violations): `#if DEBUG` / `public func f() {}` / `#endif`; `public func f() {` / `#if os(macOS)` / `return .mac` / `#endif` / `}` (platform branch inside a public body); an internal `static func make()` inside `#if canImport(UIKit)`.

## 12. Package.swift

`platforms: [.iOS(.v26), .macOS(.v26)]` (Task 1, because `glassEffect` in Task 2 needs it). Nothing else changes: same products, targets, dependencies, swift settings. Test targets need no new dependencies.

## 13. CHANGELOG entry (0.2.0)

```markdown
## 0.2.0 — 2026-11-08

Environment-driven theming, Liquid Glass default theme, and catalog primitives.

### Breaking
- Raised the platform floor to iOS 26 and macOS 26.
- Removed `BraisenlyTheme` and `BraisenlyThemeToggle`. Use `BraisenlyThemeDefinition`, `BraisenlyThemes`, `View.braisenlyTheme(_:)` and `BraisenlyThemeSwitcher`.
- Workspace, document and AI chat views take `Binding<BraisenlyThemeDefinition.ID>` (or an initial theme id) instead of `BraisenlyTheme`.
- Init parameters that defaulted to static tokens are now optional overrides (`Color? = nil`, `CGFloat? = nil`, `Font? = nil`) resolved against the environment theme.
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
```

## 14. Left to the builder

- Exact view-body code of each new wrapper/control within the contracts above.
- Choice of which of two equally near steps to use where the snapping rule leaves a tie (none expected; the rule is total).
- Layout-offset sums for values above 28 pt (≤ 8 pt delta).
- Wording of accessibility hints other than those pinned in §10.
- Test fixture strings.

**Note for the demo repo (not package work).** With the floor at macOS 26 and U-16 in force, the demo's public-views generator (`scripts/public-views.sh`) must extract the symbol graph for target `arm64-apple-macos26.0` (was `arm64-apple-macos14.0`), and it builds only the UI module, in its own scratch path so it neither resolves MLX for `BraisenlyAI` nor contends for the package's `.build` lock:

```bash
swift build --package-path ../BraisenlySwiftUI --target BraisenlySwiftUI --scratch-path ../BraisenlySwiftUI/.build-symgraph
swift symbolgraph-extract -module-name BraisenlySwiftUI -target arm64-apple-macos26.0 \
  -I ../BraisenlySwiftUI/.build-symgraph/debug/Modules -I ../BraisenlySwiftUI/.build-symgraph/debug \
  -sdk "$(xcrun --show-sdk-path --sdk macosx)" -output-dir ../BraisenlySwiftUI/.build-symgraph/symgraph \
  -minimum-access-level public
```

The scratch path name `.build-symgraph` is the Architect's call. It is currently **not** gitignored (the package's `.gitignore` lists only `.swiftpm/`, `.build/` and `.DS_Store`; verified with `git check-ignore`). Plan Task 27 adds `.build-*/` to the package `.gitignore`. The macOS graph is authoritative because U-16 guarantees iOS exposes the same public symbols.

## 15. Deviations from the coordinator plan

1. **D-2 spacing enum** is `BraisenlyStep` (`zero, xs, s, m, l, xl`) and is shared by the spacing and radius scales. `zero` added because 0 spacing is common; named `zero`, not `none`, to avoid `Optional.none` ambiguity in `BraisenlySpacer(minLength: BraisenlyStep?)`.
2. **D-2 adds `View.braisenlyPadding(_:_:)`**: the demo lint (D-5) bans numeric `.padding(`; the demo still needs padding.
3. **D-2 `BraisenlySplitView`**: background extension is opt-in (`extendsDetailBackground`) rather than automatic. HIG: `backgroundExtensionEffect` is for hero media under the sidebar, not for whole detail panes. Also adds `preferredCompactColumn` so button-driven selection pushes on iPhone.
4. **D-2 `BraisenlyIcon(systemName:size:)`** takes `BraisenlyIconSize` (token) rather than `CGFloat`, for Dynamic Type; also takes `tone`.
5. **D-3 adds `BraisenlyButton`**: the demo bans `Button(` and needs text buttons (reset knobs, copy snippet).
6. **D-1 adds `BraisenlySurfaceRole`**: glass only on controls/chrome; content surfaces stay solid in the glass theme.
7. **D-1 adds `style: .row/.cycle` to `BraisenlyThemeSwitcher`**: `.cycle` is the drop-in replacement for `BraisenlyThemeToggle` inside DocumentChrome and AIChatHeader.
8. **D-1 color token names** stay identical to `BraisenlyDS.Colors` (incl. `accentTeal`) to make migration mechanical; five semantic tokens added (`danger`, `warning`, `success`, `scrim`, `shadow`). `BraisenlyThemeDefinition` also conforms to `Equatable` (testability).
9. **Plan sequencing**: the `Package.swift` floor bump moves into Task 1 (Task 2's `glassEffect` will not compile on the iOS 17 floor without `#available`).
10. **Scope**: the 14 `BraisenlyAI` views are migrated too (forced by the `BraisenlyTheme` removal for 3 of them; the other 11 would otherwise ignore the active theme).
11. **Theme switches never change view structure** (final review 2026-11-12): card/capsule modifiers, glass group, split view and `BraisenlyButton` vary only values across glass and solid themes (`Glass.identity`, clear fills, inert `GlassEffectContainer`). `BraisenlyButton` therefore uses a private `ButtonStyle` instead of the system `.glass`/`.glassProminent` styles so the button's identity survives a switch. `braisenlySheetBackground()` keeps its branch: `presentationBackground` has no system-default value, and no package sheet contains a switcher.

## 16. Builder-check results

A fresh Sonnet builder read this spec cold on 2026-11-08 and raised 10 questions. They are resolved as follows.

| # | question | resolution |
|---|---|---|
| 1 | How old/new theme APIs coexist; where the 0.2.0 bump lands | Answered already (§7 and plan). The binding-type change for DocumentChrome, DocumentCanvas, both workspaces and MobileWorkspaceView is one atomic batch (plan Task 8), and AI-2 is another (Task 10). Each compiles because the old enum stays until Task 26. There is no `package.json`: the Swift package version is the CHANGELOG section plus the release tag. `Package.swift` changes only its platforms, in Task 1. The CHANGELOG lands last (Task 27). |
| 2 | Floor bump accepted? CI destinations? | Answered already: user decision U-6. Tests run with `swift test` on the macOS 27.2 host. The device build targets presto (plan Task 28). There is no CI in this repo. |
| 3 | Guard regex vs legitimate code; `.padding(0)`; suppressions | Minor, Architect's call. `literalPadding` now allows literal `0` and catches fractional values. There are no suppressions: sub-scale values go through `metrics.hairline`, and `.frame` literals are not scanned (§6.8, §11.1). |
| 4 | Exact 36 + 14 scope | Answered already. The list is now explicit in §6.7, and the plan batches cover it exactly (7+7+8+7+7 core, 8+6 AI). |
| 5 | Icon sizes map to text fonts? | Answered already: intended. SF Symbols size from the font, so text-style fonts give icons Dynamic Type for free. |
| 6 | `BraisenlyPlatform` vs metric tokens | Minor, Architect's call. Platform density wins wherever it is used today; metric tokens replace only the static `Metrics` reads (§6.6). |
| 7 | `.interactive()` glass on a text field | Minor, Architect's call, changed: PromptField and SidebarSearchHeader use `.chrome` (glass, not interactive) (§5.1). |
| 8 | Are signatures frozen if the demo needs more? | Minor, Architect's call. Signatures are frozen for 0.2.0. A demo gap becomes a spec amendment plus a new control task, routed through the coordinator, per D-3 ("anything the demo shell needs and cannot find goes here"). |
| 9 | Live verification for a package with no UI | Answered already by the coordinator plan. Package gates are `swift build`, `swift test`, the presto device build and `ImageRenderer` smoke tests. The live battery (presto, macOS, every entry in 3 themes, Reduce Transparency/Motion, VoiceOver) runs in the demo app (U-10, Phase 5). |
| 10 | ThemeSwitcher file placement | Minor, Architect's call. It stays at the root, as the coordinator plan's file list names it. |

## 17. Open questions for the user

All resolved. The user answered on 2026-11-08, relayed by the coordinator.

1. **macOS text size. RESOLVED:** accept the native macOS text-style sizes (`.body` = 13 pt). §4.2 stands as written.
2. **Liquid Glass accent colour. RESOLVED:** Solarized cyan `0x2AA198` (`accentTeal`), as in §4.2.
3. **New invariant U-16 (approved):** the public API is identical on iOS and macOS. See §3 and §11.2.
