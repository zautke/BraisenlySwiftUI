# Themable Tokens and Catalog Primitives Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make every BraisenlySwiftUI token environment-driven (Liquid Glass default, Solarized Light/Dark opt-in), migrate all 36 core and 14 AI views to it, and add the layout wrappers, controls, button and theme switcher the demo catalog needs. Ships as 0.2.0.

**Architecture:** One `Sendable` value type `BraisenlyThemeDefinition` (colors, typography, metrics, surface style) carried in `EnvironmentValues.braisenlyTheme`. Two surface modifiers decide glass vs solid per `BraisenlySurfaceRole`; one internal `BraisenlyGlassGroup` owns every `GlassEffectContainer`. Components read `@Environment(\.braisenlyTheme)`; a source-scan test bans static tokens and literal paddings/fonts/radii.

**Tech Stack:** Swift 6.4.2, SwiftPM tools 6.4, SwiftUI (iOS 26 / macOS 26 floor), Liquid Glass APIs, Swift Testing. Xcode 27.2 on largo.

**Spec:** `docs/superpowers/specs/2026-11-08-themable-tokens-and-catalog-primitives-design.md` (read it with this plan; section numbers below refer to it).

## Global Constraints

- Worktree `/Volumes/MACDEV/BraisenlySwiftUI-catalog`, branch `feat/themable-tokens-and-catalog-primitives`. Commits pushed to its draft PR into `development`.
- `Package.swift` platforms `.iOS(.v26), .macOS(.v26)`; `swift-tools-version: 6.4`; every target keeps `.enableUpcomingFeature("ApproachableConcurrency")`.
- No `#available`, no `@unchecked Sendable`, no `nonisolated(unsafe)`.
- U-16: the public API is identical on iOS and macOS. No `public` declaration may sit inside an `#if os(…)` or `#if canImport(…)` region anywhere under `Sources/BraisenlySwiftUI/`; platform differences live only inside bodies or internal helpers (spec §11.2).
- All token types `Sendable` + `Equatable` value types.
- Glass never on `.content` role surfaces; `GlassEffectContainer` only via `BraisenlyGlassGroup`; `.glassEffect` after layout modifiers; `.interactive()` only on `.control`.
- Every animation added is skipped when `accessibilityReduceMotion` is true.
- Fonts only from `theme.typography.*` (text styles) or `.system(size: iconSize * iconScale, …)` with `@ScaledMetric(relativeTo: .body) private var iconScale: CGFloat = 1`.
- Spacing snapping (spec §4.1): 1–5 `.xs`(4), 6–10 `.s`(8), 11–14 `.m`(12), 15–20 `.l`(16), 21–28 `.xl`(24); radius 3–5 `.xs`(4), 8–12 `.s`(10), 13–16 `.m`(14), 17–20 `.l`(20), 21–26 `.xl`(24); `spacing: 0` stays.
- Tests: Swift Testing only. Rendering tests are `@MainActor`.
- Conventional Commits with scopes (`feat(theme)`, `refactor(tokens)`, `feat(layout)`, `feat(controls)`, `test(tokens)`, `chore(release)`).
- Each task stages only the files it owns (`git add <listed files>`), never `git add -A`.
- First `swift build`/`swift test` resolves mlx-swift and takes ~4 min cold; later runs are incremental. SwiftPM serializes concurrent builds on `.build`; parallel builders should each use their own worktree branched from the feature tip (coordinator merges; file ownership is disjoint).
- No simulator. Device build only in Task 28.

## Review Focus

1. **Theme switch at runtime inside a sheet** — a sheet presented under Solarized Dark then switched to Liquid Glass must restyle; Task 8 and Task 10 re-apply `.braisenlyTheme(theme)` inside each sheet and their smoke tests render the sheet content under all three themes.
2. **Unknown or stale theme id** (persisted id from an older build, custom list) — must fall back to Liquid Glass, never trap. Task 1 tests `theme(withID: "nope")`; Task 25 tests `nextID(after: "nope")` and renders the switcher with an unknown selection.
3. **Glass nesting** — ThemeSwitcher `.row` (owns a group) inside DocumentChrome (owns a group) must not create nested containers. Task 2 tests `BraisenlyGlassGroup` inside `BraisenlyGlassGroup` sets/reads `braisenlyIsInGlassGroup` and renders.
4. **Very large Dynamic Type** — controls with fixed heights (NavRow, Button, SegmentedControl) must not clip text at accessibility sizes. Tasks 15, 16, 24 render with `.dynamicTypeSize(.accessibility5)` in their smoke test.
5. **Empty inputs** — `BraisenlyChipGroup`/`BraisenlySegmentedControl` with `options: []`, `BraisenlyPropertyTable(rows: [])`, `BraisenlyFlowLayout.rows(for: [], …)` must render empty without crashing. Tasks 16, 20, 22 include an empty-input test.

---

### Task 1: Theme model, tokens, themes, environment, floor bump

**Files:**
- Create: `Sources/BraisenlySwiftUI/Theme/BraisenlyTokens.swift` (BraisenlyStep, BraisenlyScale, BraisenlyColorTokens, BraisenlyTypographyTokens, BraisenlyMetricTokens)
- Create: `Sources/BraisenlySwiftUI/Theme/BraisenlySystemColor.swift` (internal, UIKit/AppKit semantic colors)
- Create: `Sources/BraisenlySwiftUI/Theme/BraisenlyThemeDefinition.swift` (BraisenlySurfaceStyle, BraisenlySurfaceRole, BraisenlyThemeDefinition + static forwards, `@Entry braisenlyTheme`, `View.braisenlyTheme(_: BraisenlyThemeDefinition)`)
- Create: `Sources/BraisenlySwiftUI/Theme/BraisenlyThemes.swift`
- Modify: `Package.swift` (platforms only)
- Modify: `Sources/BraisenlySwiftUI/BraisenlyDesignSystem.swift` (doc comment only: "static Solarized source values; components read `EnvironmentValues.braisenlyTheme`")
- Test: `Tests/BraisenlySwiftUITests/ThemeResolutionTests.swift`

**Interfaces:**
- Consumes: existing internal `BraisenlyRGB(_ hex: UInt32)`, `BraisenlyDS.Solarized.*`.
- Produces (exact, spec §4):
  - `public enum BraisenlyStep: String, CaseIterable, Sendable { case zero, xs, s, m, l, xl }`
  - `public struct BraisenlyScale: Sendable, Equatable { var xs, s, m, l, xl: CGFloat; init(xs:s:m:l:xl:); subscript(_ step: BraisenlyStep) -> CGFloat }`
  - `public struct BraisenlyColorTokens` — 20 `Color` vars: `backgroundPrimary, backgroundDimmed, surfaceSheet, surfaceElevated, surfaceHighlight, surfaceSnippet, borderSubtle, divider, accentTeal, textPrimary, textBright, textSecondary, textDisabled, matchBackground, matchForeground, danger, warning, success, scrim, shadow`; `static func solarized(_ scheme: ColorScheme) -> Self`; `static var system: Self`
  - `public struct BraisenlyTypographyTokens` — 14 `Font` vars: `documentTitle, vaultTitle, bodyReading, rowLabel, rowLabelMedium, snippetBody, metadata, badgeNumber, code, labelEmphasis, chipLabel, rowIcon, controlIcon, controlIconEmphasis`; `static let standard`
  - `public struct BraisenlyMetricTokens` — `spacing: BraisenlyScale, radius: BraisenlyScale, circleButtonSize, toolbarHeight, rowHeight, sidebarWidthRatio, hairline, sheetCornerRadius: CGFloat, grabberSize: CGSize`; `static let standard`
  - `public enum BraisenlySurfaceStyle: Sendable, Equatable { case glass(Glass), solid; func glass(for role: BraisenlySurfaceRole) -> Glass? }`
  - `public enum BraisenlySurfaceRole: Sendable, Equatable { case content, control, chrome }`
  - `public struct BraisenlyThemeDefinition: Sendable, Identifiable, Equatable` (fields and init per spec §4.4); `static var liquidGlass/solarizedLight/solarizedDark: Self`
  - `public enum BraisenlyThemes { static let liquidGlass, solarizedLight, solarizedDark: BraisenlyThemeDefinition; static let all; static func theme(withID:in:) -> BraisenlyThemeDefinition; static func nextID(after:in:) -> BraisenlyThemeDefinition.ID }`
  - `EnvironmentValues.braisenlyTheme: BraisenlyThemeDefinition` (default `.liquidGlass`)
  - `View.braisenlyTheme(_ theme: BraisenlyThemeDefinition) -> some View` (environment + `preferredColorScheme(theme.colorScheme)` + `.tint(theme.colors.accentTeal)`). The old `braisenlyTheme(_: BraisenlyTheme)` overload stays until Task 26.

- [ ] **Step 1: Write the failing test** `Tests/BraisenlySwiftUITests/ThemeResolutionTests.swift`

```swift
import SwiftUI
import Testing
@testable import BraisenlySwiftUI

@Test func builtInThemesHaveStableIDsInOrder() {
    #expect(BraisenlyThemes.all.map(\.id) == ["liquidGlass", "solarizedLight", "solarizedDark"])
    #expect(BraisenlyThemes.all.map(\.name) == ["Liquid Glass", "Solarized Light", "Solarized Dark"])
    #expect(BraisenlyThemes.all.map(\.symbolName) == ["sparkles", "sun.max.fill", "moon.stars.fill"])
}

@Test func environmentDefaultsToLiquidGlass() {
    #expect(EnvironmentValues().braisenlyTheme == .liquidGlass)
}

@Test func themesPinExpectedColorSchemesAndSurfaces() {
    #expect(BraisenlyThemes.liquidGlass.colorScheme == nil)
    #expect(BraisenlyThemes.solarizedLight.colorScheme == .light)
    #expect(BraisenlyThemes.solarizedDark.colorScheme == .dark)
    #expect(BraisenlyThemes.liquidGlass.surface == .glass(.regular))
    #expect(BraisenlyThemes.solarizedLight.surface == .solid)
    #expect(BraisenlyThemes.solarizedDark.surface == .solid)
}

@Test func unknownThemeIDFallsBackToLiquidGlass() {
    #expect(BraisenlyThemes.theme(withID: "nope") == .liquidGlass)
    #expect(BraisenlyThemes.theme(withID: "solarizedDark") == .solarizedDark)
}

@Test func nextIDWrapsAndRecoversFromUnknown() {
    #expect(BraisenlyThemes.nextID(after: "liquidGlass") == "solarizedLight")
    #expect(BraisenlyThemes.nextID(after: "solarizedDark") == "liquidGlass")
    #expect(BraisenlyThemes.nextID(after: "nope") == "liquidGlass")
    #expect(BraisenlyThemes.nextID(after: "x", in: []) == "x")
}

@Test func scalesMatchSpecValues() {
    let m = BraisenlyMetricTokens.standard
    #expect(BraisenlyStep.allCases.map { m.spacing[$0] } == [0, 4, 8, 12, 16, 24])
    #expect(BraisenlyStep.allCases.map { m.radius[$0] } == [0, 4, 10, 14, 20, 24])
    #expect(m.sheetCornerRadius == 28 && m.grabberSize == CGSize(width: 46, height: 5) && m.hairline == 0.5)
}

@Test func solarizedColorsComeFromThePalette() {
    #expect(BraisenlyThemes.solarizedDark.colors.backgroundPrimary == BraisenlyDS.Solarized.base03)
    #expect(BraisenlyThemes.solarizedLight.colors.backgroundPrimary == BraisenlyDS.Solarized.base3)
    #expect(BraisenlyThemes.liquidGlass.colors.accentTeal == BraisenlyDS.Solarized.cyan)
    #expect(BraisenlyThemes.solarizedDark.colors.danger == BraisenlyDS.Solarized.red)
}

@Test(arguments: [BraisenlySurfaceRole.content, .control, .chrome])
func glassTruthTable(role: BraisenlySurfaceRole) {
    #expect(BraisenlySurfaceStyle.solid.glass(for: role) == nil)
    let expected: Glass? = switch role {
        case .content: nil
        case .control: Glass.regular.interactive()
        case .chrome: Glass.regular
    }
    #expect(BraisenlySurfaceStyle.glass(.regular).glass(for: role) == expected)
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `swift test --filter ThemeResolutionTests`
Expected: FAIL to compile, "cannot find 'BraisenlyThemes' in scope".

- [ ] **Step 3: Implement the four Theme files and bump `Package.swift` platforms to `.iOS(.v26), .macOS(.v26)`**

Values exactly per spec §4.2 tables (colors, typography, metrics) and §4.4 table (themes). `solarized(_:)` builds every color from `BraisenlyRGB` hex via `Color(red:green:blue:)` — the same construction `BraisenlyDS.Solarized` uses, so equality holds. `BraisenlySystemColor` mirrors `BraisenlyAdaptiveColor`'s `#if canImport(UIKit)` / `AppKit` structure with the spec §4.2 mapping. Every declaration inside those branches stays internal (U-16): the public `BraisenlyColorTokens.system` sits outside any `#if`. `scrim` = `Color.black.opacity(0.38)`, `shadow` = `Color.black.opacity(0.35)` (Theme/ files are exempt from the source scan).

- [ ] **Step 4: Run test to verify it passes**

Run: `swift test --filter ThemeResolutionTests` then `swift build`
Expected: all ThemeResolutionTests PASS; build succeeds (old components still compile against `BraisenlyDS`).

- [ ] **Step 5: Commit**

```bash
git add Package.swift Sources/BraisenlySwiftUI/Theme Sources/BraisenlySwiftUI/BraisenlyDesignSystem.swift Tests/BraisenlySwiftUITests/ThemeResolutionTests.swift
git commit -m "feat(theme): add environment-driven BraisenlyThemeDefinition and raise floor to iOS 26/macOS 26"
```

---

### Task 2: Surface modifiers, glass group, sheet background, render helper

**Files:**
- Modify: `Sources/BraisenlySwiftUI/BraisenlyCardModifier.swift`
- Modify: `Sources/BraisenlySwiftUI/BraisenlyCapsuleModifier.swift`
- Create: `Sources/BraisenlySwiftUI/BraisenlyGlassGroup.swift` (internal view + internal `@Entry var braisenlyIsInGlassGroup`)
- Create: `Sources/BraisenlySwiftUI/BraisenlySheetBackground.swift` (`View.braisenlySheetBackground()`)
- Create: `Tests/BraisenlySwiftUITests/Support/RenderSmoke.swift`
- Test: `Tests/BraisenlySwiftUITests/SurfaceModifierTests.swift`

**Interfaces:**
- Consumes: Task 1 (`BraisenlyThemeDefinition`, `BraisenlySurfaceRole`, `BraisenlySurfaceStyle.glass(for:)`, `theme.metrics.radius/spacing/hairline/sheetCornerRadius`, `theme.colors.*`).
- Produces (spec §5):
  - `BraisenlyCardModifier(cornerRadius: CGFloat? = nil, fill: Color? = nil, role: BraisenlySurfaceRole = .content)`; public stored `cornerRadius: CGFloat?`, `fill: Color?`, `role`
  - `BraisenlyCapsuleModifier(fill: Color? = nil, role: BraisenlySurfaceRole = .control)`; public stored `fill: Color?`, `role`
  - `View.braisenlyCard(cornerRadius: CGFloat? = nil, fill: Color? = nil, role: BraisenlySurfaceRole = .content) -> some View`
  - `View.braisenlyCapsule(fill: Color? = nil, role: BraisenlySurfaceRole = .control) -> some View`
  - `View.braisenlySheetBackground() -> some View`
  - internal `BraisenlyGlassGroup<Content: View>(spacing: BraisenlyStep = .s, @ViewBuilder content: () -> Content)`; internal `EnvironmentValues.braisenlyIsInGlassGroup: Bool`
  - test helper `@MainActor enum RenderSmoke { static func renders<V: View>(_ view: V, theme: BraisenlyThemeDefinition, size: CGSize = CGSize(width: 390, height: 640), dynamicType: DynamicTypeSize = .large) -> Bool }` (ImageRenderer of `view.braisenlyTheme(theme).dynamicTypeSize(dynamicType).frame(width:height:)`, returns `cgImage != nil`)

- [ ] **Step 1: Write the failing test** `Tests/BraisenlySwiftUITests/SurfaceModifierTests.swift`

```swift
import SwiftUI
import Testing
@testable import BraisenlySwiftUI

@Test func cardAndCapsuleDefaults() {
    let card = BraisenlyCardModifier()
    #expect(card.cornerRadius == nil && card.fill == nil && card.role == .content)
    let capsule = BraisenlyCapsuleModifier()
    #expect(capsule.fill == nil && capsule.role == .control)
}

@MainActor @Test(arguments: BraisenlyThemes.all)
func surfacesRenderInEveryTheme(theme: BraisenlyThemeDefinition) {
    let view = VStack {
        Text("card").braisenlyCard()
        Text("chrome").braisenlyCard(role: .chrome)
        Text("pill").braisenlyCapsule()
        BraisenlyGlassGroup { BraisenlyGlassGroup { Text("nested").braisenlyCapsule() } }
    }
    #expect(RenderSmoke.renders(view, theme: theme))
}

@MainActor @Test func glassGroupMarksDescendants() {
    var seen: Bool?
    let probe = BraisenlyGlassGroup { EnvironmentReader { seen = $0.braisenlyIsInGlassGroup } }
    _ = RenderSmoke.renders(probe, theme: .liquidGlass)
    #expect(seen == true)
}
```

`EnvironmentReader` is a 5-line test-only view in `RenderSmoke.swift`: `struct EnvironmentReader: View { @Environment(\.self) var env; let read: (EnvironmentValues) -> Void; var body: some View { Color.clear.onAppear { read(env) } } }` — if `onAppear` does not fire under `ImageRenderer`, read the value in `body` instead (call `read(env)` before returning `Color.clear`).

- [ ] **Step 2: Run test to verify it fails**

Run: `swift test --filter SurfaceModifierTests`
Expected: FAIL to compile, "extra argument 'role' in call" / "cannot find 'BraisenlyGlassGroup'".

- [ ] **Step 3: Implement the modifiers, `BraisenlyGlassGroup`, `braisenlySheetBackground()` and `RenderSmoke`**

Rendering per spec §5 behavior table. Modifiers read `@Environment(\.braisenlyTheme)`. Glass path: `content.glassEffect(glass, in: shape)` where `glass = theme.surface.glass(for: role)`; solid path keeps today's fill/stroke/shadow with tokens (stroke width `theme.metrics.hairline * 1.6`, capsule shadow `theme.colors.shadow`, radius 12, y 6). `BraisenlyGlassGroup`: solid theme or already-in-group → `content` + env true; else `GlassEffectContainer(spacing: theme.metrics.spacing[spacing]) { content }.environment(\.braisenlyIsInGlassGroup, true)`. Sheet background: `presentationCornerRadius(theme.metrics.sheetCornerRadius)` always; `presentationBackground(theme.colors.surfaceSheet)` only when `theme.surface == .solid`.

- [ ] **Step 4: Run tests**

Run: `swift test --filter SurfaceModifierTests` then `swift build`
Expected: PASS (3 themes × render + defaults + group marker); build succeeds — existing call sites like `.braisenlyCard(cornerRadius: 24)` still compile.

- [ ] **Step 5: Commit**

```bash
git add Sources/BraisenlySwiftUI/BraisenlyCardModifier.swift Sources/BraisenlySwiftUI/BraisenlyCapsuleModifier.swift Sources/BraisenlySwiftUI/BraisenlyGlassGroup.swift Sources/BraisenlySwiftUI/BraisenlySheetBackground.swift Tests/BraisenlySwiftUITests/Support/RenderSmoke.swift Tests/BraisenlySwiftUITests/SurfaceModifierTests.swift
git commit -m "feat(theme): theme-aware card/capsule surfaces with glass roles and single glass-group owner"
```

---

### Task 3: Source-scan guard helper (parallel with Task 1)

**Files:**
- Create: `Tests/BraisenlySwiftUITests/Support/SourceScan.swift`
- Test: `Tests/BraisenlySwiftUITests/SourceScanTests.swift`

**Interfaces:**
- Consumes: nothing (pure file/regex scan).
- Produces:
  - `enum SourceScan { static let bannedPatterns: [(id: String, regex: String)]; static let exemptPrefixes: [String]; static func violations(inSource source: String, named name: String) -> [String]; static func violations(in relativePaths: [String]) throws -> [String]; static func allSwiftSources() throws -> [String] }`
  - U-16 rule (spec §11.2): `static func platformConditionalPublicViolations(inSource source: String, named name: String) -> [String]`, `static func platformConditionalPublicViolations(in relativePaths: [String]) throws -> [String]`, `static func moduleSources(_ module: String) throws -> [String]` (every `.swift` under `Sources/<module>/`, sorted, **no** exemptions). Violation format `"<file>:<line>: platformConditionalPublic"`. Algorithm: `#if` frame stack, frame is platform when its `#if`/`#elseif` condition contains `os(` or `canImport(`, pop on `#endif`; flag lines matching `^\s*(@[A-Za-z_]+(\([^)]*\))?\s+)*(nonisolated\s+)?public\s` while any frame is platform; skip `//` lines.
  - Patterns and exempt list exactly spec §11.1. Paths are relative to package root, e.g. `"Sources/BraisenlySwiftUI/BraisenlyModelPill.swift"`; root = `URL(filePath: #filePath)` up three levels (`Support` → `BraisenlySwiftUITests` → `Tests` → root). Violation string format: `"<relativePath>:<line>: <patternID>"`. Lines that are `//` comments are skipped.

- [ ] **Step 1: Write the failing test** `Tests/BraisenlySwiftUITests/SourceScanTests.swift`

```swift
import Testing

// Negative tests: PASS means each declared offending line is caught exactly once.
@Test(arguments: [
    ("Text(\"a\").foregroundStyle(BraisenlyDS.Colors.textPrimary)", "staticToken"),
    (".font(.system(size: 18, weight: .medium))", "fixedFont"),
    (".padding(.horizontal, 14)", "literalPadding"),
    (".padding(.horizontal, 1.5)", "literalPadding"),
    (".padding(.top, isMac ? 16 : 10)", "ternaryPadding"),
    ("VStack(spacing: 12) {", "literalSpacing"),
    ("RoundedRectangle(cornerRadius: 14)", "literalRadius"),
    ("Color.black.opacity(0.38)", "colorLiteral"),
])
func detectsEachBannedPattern(line: String, patternID: String) {
    #expect(SourceScan.violations(inSource: line, named: "X.swift") == ["X.swift:1: \(patternID)"])
}

@Test func allowsTokenizedCode() {
    let ok = """
    .padding(.horizontal, theme.metrics.spacing[.m])
    VStack(spacing: 0) {
    .padding(0)
    .font(.system(size: iconSize * iconScale, weight: .medium))
    // BraisenlyDS.Colors.textPrimary in a comment is fine
    """
    #expect(SourceScan.violations(inSource: ok, named: "Y.swift").isEmpty)
}

// U-16 negative tests: PASS means the public declaration inside a platform region is reported on the declared line.
@Test(arguments: [
    ("#if os(macOS)\npublic struct X {}\n#endif", 2),
    ("#if canImport(UIKit)\n#elseif canImport(AppKit)\n    public init() {}\n#endif", 3),
    ("#if canImport(UIKit)\n#else\n@MainActor public func f() {}\n#endif", 3),
    ("#if DEBUG\n#if os(iOS)\npublic extension View {}\n#endif\n#endif", 3),
])
func detectsPublicDeclarationInPlatformRegion(source: String, line: Int) {
    #expect(SourceScan.platformConditionalPublicViolations(inSource: source, named: "N.swift")
            == ["N.swift:\(line): platformConditionalPublic"])
}

@Test(arguments: [
    "#if DEBUG\npublic func f() {}\n#endif",
    "public func f() -> P {\n#if os(macOS)\nreturn .mac\n#endif\n}",
    "#if canImport(UIKit)\nstatic func make() {}\n#endif",
    "#if os(macOS)\n// public struct Commented {}\n#endif",
])
func allowsPlatformBranchesWithoutPublicDeclarations(source: String) {
    #expect(SourceScan.platformConditionalPublicViolations(inSource: source, named: "P.swift").isEmpty)
}

@Test func moduleSourcesIncludeExemptTokenFiles() throws {
    let files = try SourceScan.moduleSources("BraisenlySwiftUI")
    #expect(files.contains("Sources/BraisenlySwiftUI/BraisenlyAdaptiveColor.swift"))
    #expect(files.contains("Sources/BraisenlySwiftUI/BraisenlyPlatform.swift"))
    #expect(!files.contains { $0.hasPrefix("Sources/AI/") })
}

@Test func findsPackageSources() throws {
    let files = try SourceScan.allSwiftSources()
    #expect(files.contains("Sources/BraisenlySwiftUI/BraisenlyModelPill.swift"))
    #expect(!files.contains { $0.hasPrefix("Sources/BraisenlySwiftUI/Theme/") })
    #expect(!files.contains { $0.hasPrefix("Sources/AI/Models/") })
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `swift test --filter SourceScanTests`
Expected: FAIL to compile, "cannot find 'SourceScan' in scope".

- [ ] **Step 3: Implement `SourceScan`** with `NSRegularExpression` (or Swift `Regex`) over each line; `allSwiftSources()` enumerates `Sources/` recursively with `FileManager.enumerator`, returns sorted relative paths minus `exemptPrefixes`. When two patterns match one line (e.g. `literalPadding` and `ternaryPadding` cannot both match by construction), report each match. Implement the U-16 frame-stack scan and `moduleSources(_:)` per the Interfaces block (`moduleSources` shares the enumerator but applies no exemptions).

- [ ] **Step 4: Run test to verify it passes**

Run: `swift test --filter SourceScanTests`
Expected: 8 + 4 + 4 parameterized cases and 3 plain tests PASS.

- [ ] **Step 4b: Confirm the current tree already complies with U-16**

Run: `git grep -n -A4 "#if os\|#if canImport\|#elseif canImport\|#else" -- Sources/BraisenlySwiftUI | grep public || echo clean`
Expected: `clean` (Architect ran it on 2026-11-08 at tip `62c2480`; the only platform branches are in the `BraisenlyPlatform.resolved` body and in `BraisenlyAdaptiveColor`'s imports and internal `make`). The repo-wide assertion itself lands in Task 27.

- [ ] **Step 5: Commit**

```bash
git add Tests/BraisenlySwiftUITests/Support/SourceScan.swift Tests/BraisenlySwiftUITests/SourceScanTests.swift
git commit -m "test(tokens): add source-scan guard for static tokens and literal metrics"
```

---

### Tasks 4–8: Token migration batches (core views)

Every batch task follows spec §6 rules 1–4 for its files only and has the same five steps. Batches 4–7 run in parallel after Tasks 2 and 3; batch 8 also needs Task 25.

Shared step shape (each task spells out its own file list and roles):

- [ ] Step 1: write `Tests/BraisenlySwiftUITests/TokenMigration<Batch>Tests.swift`:
```swift
import SwiftUI
import Testing
@testable import BraisenlySwiftUI

private let files = [/* this batch's Sources paths */]

@Test func <batch>FilesHaveNoStaticTokensOrLiteralMetrics() throws {
    #expect(try SourceScan.violations(in: files) == [])
}

@MainActor @Test(arguments: BraisenlyThemes.all)
func <batch>ViewsRender(theme: BraisenlyThemeDefinition) {
    // one #expect(RenderSmoke.renders(<View>(minimal args; .constant bindings; {} closures), theme: theme)) per view in the batch
}
```
- [ ] Step 2: `swift test --filter TokenMigration<Batch>Tests` — Expected: FAIL, the scan lists `<file>:<line>: staticToken` etc.
- [ ] Step 3: migrate the files (spec §6; roles from spec §5.1; owners from §5.2).
- [ ] Step 4: `swift test --filter TokenMigration<Batch>Tests` then `swift test --filter BraisenlySwiftUITests` — Expected: PASS, and the pre-existing `chatPrimitivesStoreConfigurationProperties` still passes.
- [ ] Step 5: `git add <batch files> Tests/BraisenlySwiftUITests/TokenMigration<Batch>Tests.swift && git commit -m "refactor(tokens): migrate <batch> to environment theme"`.

### Task 4: Migration batch B1 — buttons and pills

**Files:** Modify `Sources/BraisenlySwiftUI/` `BraisenlyCircleIconButton.swift`, `BraisenlyToolbarIconButton.swift`, `BraisenlySendStopButton.swift`, `BraisenlyDualActionPill.swift`, `BraisenlyMessageActionPill.swift`, `BraisenlyModelPill.swift`, `BraisenlyCitationPill.swift`. Test: `Tests/BraisenlySwiftUITests/TokenMigrationB1Tests.swift`.

**Interfaces:**
- Consumes: Task 1 tokens (`controlIcon`, `controlIconEmphasis`, `chipLabel`, `colors.warning`), Task 2 `braisenlyCapsule(fill:role:)`, Task 3 `SourceScan`, Task 2 `RenderSmoke`.
- Produces: no public signature changes. ModelPill capsule role `action == nil ? .chrome : .control`; all others default `.control`. SendStopButton stop color `colors.warning` (was `Solarized.orange`). CircleIconButton keeps `iconSize: CGFloat = 18` and scales it with `@ScaledMetric`.

Steps 1–5 as in the shared shape, test prefix `b1`.

### Task 5: Migration batch B2 — indicators and fields

**Files:** Modify `BraisenlyAvatarBadge.swift`, `BraisenlyTabCounterBadge.swift`, `BraisenlyPulseIndicator.swift`, `BraisenlyHighlightedText.swift`, `BraisenlyPromptField.swift`, `BraisenlyKeyEntryField.swift`, `BraisenlyParameterSliderRow.swift` (all under `Sources/BraisenlySwiftUI/`). Test: `TokenMigrationB2Tests.swift`.

**Interfaces:**
- Consumes: Tasks 1–3.
- Produces (public signature changes, spec §6.4):
  - `BraisenlyAvatarBadge(systemName: String, foregroundColor: Color? = nil, backgroundColor: Color? = nil, borderColor: Color? = nil, size: CGFloat = 32, iconSize: CGFloat = 14)`
  - `BraisenlyHighlightedText(_ text: String, highlight: String, font: Font? = nil, baseColor: Color? = nil)`
  - `BraisenlyPromptField(_ placeholder: LocalizedStringResource = "Message Braisenly…", text: Binding<String>, cornerRadius: CGFloat? = nil, fill: Color? = nil, onSubmit: @escaping () -> Void = {})`; card role `.chrome` (text field: glass, not interactive)
- Extra assertion in Step 1: `#expect(BraisenlyAvatarBadge(systemName: "x").foregroundColor == nil)` and `#expect(BraisenlyPromptField(text: .constant("")).cornerRadius == nil)`.

### Task 6: Migration batch B3 — cards and rows

**Files:** Modify `BraisenlyBannerCard.swift`, `BraisenlyStatusCard.swift`, `BraisenlySuggestionCard.swift`, `BraisenlyCodeBlockCard.swift`, `BraisenlyChatBubbleSurface.swift`, `BraisenlySearchSnippetCard.swift`, `BraisenlyConversationRow.swift`, `BraisenlySearchMetadataRow.swift`. Test: `TokenMigrationB3Tests.swift`.

**Interfaces:**
- Consumes: Tasks 1–3.
- Produces:
  - `BraisenlyBannerCard(message: String, systemImage: String = "exclamationmark.triangle.fill", iconColor: Color? = nil, onDismiss: (() -> Void)? = nil)` — nil → `colors.danger`
  - `BraisenlyStatusCard(title: String, subtitle: String = "", systemImage: String, iconColor: Color? = nil)` — nil → `accentTeal`
  - `BraisenlyChatBubbleSurface(text: String, fill: Color? = nil, foregroundColor: Color? = nil, cornerRadius: CGFloat? = nil)` — nil → `surfaceElevated`, `textPrimary`, `radius[.l]`
  - All cards role `.content`. CodeBlockCard code font `typography.code`.
- Extra assertion: `#expect(BraisenlyChatBubbleSurface(text: "x").cornerRadius == nil)`.

### Task 7: Migration batch B4 — action rows and sidebar

**Files:** Modify `BraisenlyActionRow.swift`, `BraisenlyActionGroup.swift`, `BraisenlyExpandableSearchResult.swift`, `BraisenlySidebarSearchHeader.swift`, `BraisenlySidebarFooter.swift`, `BraisenlySidebarContextPopover.swift`, `BraisenlySidebarDrawer.swift`. Test: `TokenMigrationB4Tests.swift`.

**Interfaces:**
- Consumes: Tasks 1–3; internal `BraisenlyGlassGroup`.
- Produces: no public signature changes. SidebarSearchHeader capsule role `.chrome` (text field). SidebarContextPopover card role `.chrome`, shadow `colors.shadow` only when `theme.surface == .solid`. SidebarDrawer wraps its content in one `BraisenlyGlassGroup`. SidebarDrawer bottom inset 104/126 → metric sum (≤ 8 pt delta).

### Task 8: Migration batch B5 — document and workspaces (after Task 25)

**Files:** Modify `BraisenlyBottomToolbar.swift`, `BraisenlyDocumentActionSheet.swift`, `BraisenlyDocumentChrome.swift`, `BraisenlyDocumentCanvas.swift`, `BraisenlyCompactWorkspace.swift`, `BraisenlyRegularWorkspace.swift`, `BraisenlyMobileWorkspaceView.swift`. Test: `TokenMigrationB5Tests.swift`.

**Interfaces:**
- Consumes: Tasks 1–3; Task 25 `BraisenlyThemeSwitcher(selection:themes:style:platform:)`, `BraisenlyThemeSwitcherStyle.cycle`; Task 2 `braisenlySheetBackground()`.
- Produces (spec §6.5):
  - `BraisenlyDocumentChrome(theme: Binding<BraisenlyThemeDefinition.ID> = .constant(BraisenlyThemes.liquidGlass.id), platform: BraisenlyPlatform = .automatic, onToggleSidebar: …, onEdit: …, onOpenActionSheet: …)` — replaces `BraisenlyThemeToggle` with `BraisenlyThemeSwitcher(selection: theme, style: .cycle, platform: platform)`; owns one `BraisenlyGlassGroup`
  - `BraisenlyDocumentCanvas(title:bodyText:theme: Binding<BraisenlyThemeDefinition.ID> = .constant(BraisenlyThemes.liquidGlass.id), platform:onToggleSidebar:onEdit:onOpenActionSheet:)`
  - `BraisenlyCompactWorkspace(…, theme: Binding<BraisenlyThemeDefinition.ID>)`, `BraisenlyRegularWorkspace(…, theme: Binding<BraisenlyThemeDefinition.ID>)` (other params unchanged)
  - `BraisenlyMobileWorkspaceView(documentTitle: String = "Home", documentText: String = sampleText, initialTheme: BraisenlyThemeDefinition.ID = BraisenlyThemes.liquidGlass.id, platform: BraisenlyPlatform = .automatic)`; applies `.braisenlyTheme(BraisenlyThemes.theme(withID: themeID))`; its `.sheet` uses `braisenlySheetBackground()` and re-applies `.braisenlyTheme(…)` inside the sheet
  - BottomToolbar: capsule role `.chrome`; owns one `BraisenlyGlassGroup`. CompactWorkspace scrim `colors.scrim`. Grabber `theme.metrics.grabberSize`.
- Extra Step 1 test (Review Focus 1): render `BraisenlyDocumentActionSheet()` (the sheet content) under all three themes, and `BraisenlyMobileWorkspaceView(initialTheme: "nope")` renders (falls back to Liquid Glass).

---

### Tasks 9–10: Token migration batches (AI views)

Same shared shape as Tasks 4–8, with two differences: the source-scan test lives in `Tests/BraisenlySwiftUITests/TokenMigration<Batch>Tests.swift` (file scan, no AI import), and the render test lives in `Tests/BraisenlyAITests/AITokenMigration<Batch>Tests.swift` with `import BraisenlyAI` and a local 3-line render helper (the AI test target cannot see `RenderSmoke`). Run with `swift test --filter TokenMigration<Batch>Tests` and `swift test --filter AITokenMigration<Batch>Tests`.

### Task 9: Migration batch AI-1 — AI leaves

**Files:** Modify `Sources/AI/UI/` `AIChatErrorBanner.swift`, `AICitationChip.swift`, `AIComposer.swift`, `AIEmptyState.swift`, `AIMessageBubble.swift`, `AIMessageList.swift`, `AIStreamingIndicator.swift`, `AIToolCallCard.swift`. Tests: `Tests/BraisenlySwiftUITests/TokenMigrationAI1Tests.swift`, `Tests/BraisenlyAITests/AITokenMigrationAI1Tests.swift`.

**Interfaces:**
- Consumes: Tasks 1–3, public API only (`@Environment(\.braisenlyTheme)`, token names). `BraisenlyGlassGroup` is internal to `BraisenlySwiftUI` and invisible here, so AIComposer and AIChatHeader own **no** container; their leaves' glass renders standalone (Architect's call; this amends spec §5.2, whose owner table lists them — zero nesting risk, slight loss of glass blending between adjacent AI controls).
- Produces: no public signature changes. AIToolCallCard status colors `colors.success` / `colors.danger`; AIChatErrorBanner passes no `iconColor` (BannerCard default resolves to `danger`). Fixtures for render tests: `AIMessage(role: .assistant, text: "Hi")`, `AIToolCall(name: "search", state: .complete)`, `AICitation(title: "Doc")`, `AIChatFailure.responseUnavailable`.

### Task 10: Migration batch AI-2 — AI compounds (after Task 25)

**Files:** Modify `Sources/AI/UI/` `AIChatHeader.swift`, `AIChatView.swift`, `AIChatWorkspaceView.swift`, `AIConversationActionSheet.swift`, `AIConversationSidebar.swift`, `AIModelSettingsSheet.swift`. Tests: `Tests/BraisenlySwiftUITests/TokenMigrationAI2Tests.swift`, `Tests/BraisenlyAITests/AITokenMigrationAI2Tests.swift`.

**Interfaces:**
- Consumes: Tasks 1–3, Task 25.
- Produces (spec §6.5):
  - `AIChatHeader(title: String, modelName: String? = nil, theme: Binding<BraisenlyThemeDefinition.ID>, platform: …, onToggleSidebar:…, onNewChat:…, onSelectModel:…, onMoreActions:…)` using `BraisenlyThemeSwitcher(selection: theme, style: .cycle, platform: platform)`
  - `AIChatView(session: AIChatSession, platform: …, initialTheme: BraisenlyThemeDefinition.ID = BraisenlyThemes.liquidGlass.id, theme: Binding<BraisenlyThemeDefinition.ID>? = nil, modelName: …, onToggleSidebar: …, onNewChat: …, onSelectModel: …, onMoreActions: …)` — applies the theme only when `theme == nil`
  - `AIChatWorkspaceView(controller: AIChatWorkspaceController, initialTheme: BraisenlyThemeDefinition.ID = BraisenlyThemes.liquidGlass.id, platform: …)`; both `.sheet`s use `braisenlySheetBackground()` and re-apply the theme inside; scrim `colors.scrim`; grabbers `metrics.grabberSize`
  - Update the existing `Tests/BraisenlyAITests/BraisenlyAITests.swift` call sites only if they pass `BraisenlyTheme` (grep first; currently none expected).
- Render fixtures: `AIChatSession(client: MockClient())` with a `MockClient: AIChatClient` returning an empty stream; `AIChatWorkspaceController(store: AIConversationStore(fileURL: <tmp file>), defaults: UserDefaults(suiteName: "ai2-\(UUID())")!)`.

---

### Task 11: Layout A — stacks, spacer, divider, padding

**Files:**
- Create: `Sources/BraisenlySwiftUI/Layout/BraisenlyVStack.swift`, `BraisenlyHStack.swift`, `BraisenlyZStack.swift`, `BraisenlySpacer.swift`, `BraisenlyDivider.swift`, `BraisenlyPadding.swift`
- Test: `Tests/BraisenlySwiftUITests/LayoutStackTests.swift`

**Interfaces:**
- Consumes: Task 1 (`BraisenlyStep`, `theme.metrics.spacing`, `theme.colors.divider`), Task 2 `RenderSmoke`.
- Produces (spec §8): `BraisenlyVStack(alignment: HorizontalAlignment = .center, spacing: BraisenlyStep = .m, content:)`, `BraisenlyHStack(alignment: VerticalAlignment = .center, spacing: BraisenlyStep = .m, content:)`, `BraisenlyZStack(alignment: Alignment = .center, content:)`, `BraisenlySpacer(minLength: BraisenlyStep? = nil)`, `BraisenlyDivider()`, `View.braisenlyPadding(_ edges: Edge.Set = .all, _ step: BraisenlyStep = .m)`. Each wrapper stores `alignment`, `spacing`/`minLength` as public `let` for tests.

- [ ] **Step 1: Write the failing test**

```swift
@Test func stacksDefaultToMediumSpacing() {
    #expect(BraisenlyVStack { EmptyView() }.spacing == .m)
    #expect(BraisenlyHStack(spacing: .xl) { EmptyView() }.spacing == .xl)
    #expect(BraisenlySpacer().minLength == nil)
}
@MainActor @Test(arguments: BraisenlyThemes.all)
func layoutPrimitivesRender(theme: BraisenlyThemeDefinition) {
    let v = BraisenlyVStack { BraisenlyHStack { Text("a"); BraisenlySpacer(minLength: .s); Text("b") }
        BraisenlyDivider(); BraisenlyZStack { Text("z") }.braisenlyPadding(.horizontal, .l) }
    #expect(RenderSmoke.renders(v, theme: theme))
}
```
- [ ] **Step 2:** `swift test --filter LayoutStackTests` — Expected: FAIL, "cannot find 'BraisenlyVStack' in scope".
- [ ] **Step 3:** Implement six one-type files as one-liners over `VStack/HStack/ZStack/Spacer/Divider/.padding` resolving steps via `theme.metrics.spacing[step]`; `BraisenlyDivider` = `Divider().overlay(theme.colors.divider)`.
- [ ] **Step 4:** `swift test --filter LayoutStackTests` — Expected: PASS.
- [ ] **Step 5:** `git add Sources/BraisenlySwiftUI/Layout/BraisenlyVStack.swift Sources/BraisenlySwiftUI/Layout/BraisenlyHStack.swift Sources/BraisenlySwiftUI/Layout/BraisenlyZStack.swift Sources/BraisenlySwiftUI/Layout/BraisenlySpacer.swift Sources/BraisenlySwiftUI/Layout/BraisenlyDivider.swift Sources/BraisenlySwiftUI/Layout/BraisenlyPadding.swift Tests/BraisenlySwiftUITests/LayoutStackTests.swift && git commit -m "feat(layout): add themed stack, spacer, divider and padding wrappers"`

### Task 12: Layout B — text and icon

**Files:**
- Create: `Sources/BraisenlySwiftUI/Layout/BraisenlyTextStyle.swift` (`BraisenlyTextStyle`, `BraisenlyTone`, `BraisenlyIconSize`), `BraisenlyText.swift`, `BraisenlyIcon.swift`
- Test: `Tests/BraisenlySwiftUITests/LayoutTextTests.swift`

**Interfaces:**
- Consumes: Task 1 typography/color tokens, Task 2 `RenderSmoke`.
- Produces (spec §8): `BraisenlyTextStyle` (11 cases) with `font(in: BraisenlyTypographyTokens) -> Font`; `BraisenlyTone` (8 cases) with `color(in: BraisenlyColorTokens) -> Color`; `BraisenlyIconSize { small, medium, large }` with `font(in:)` → `chipLabel`/`rowIcon`/`controlIcon`; `BraisenlyText(_ key: LocalizedStringKey, style: = .rowLabel, tone: = .primary)` and `@_disfavoredOverload init<S: StringProtocol>(_ content: S, style:tone:)`; `BraisenlyIcon(systemName: String, size: BraisenlyIconSize = .medium, tone: BraisenlyTone = .primary)`.

- [ ] **Step 1: Write the failing test**

```swift
@Test func everyTextStyleMapsToItsToken() {
    let t = BraisenlyTypographyTokens.standard
    let map: [BraisenlyTextStyle: Font] = [.documentTitle: t.documentTitle, .vaultTitle: t.vaultTitle,
        .bodyReading: t.bodyReading, .rowLabel: t.rowLabel, .rowLabelMedium: t.rowLabelMedium,
        .snippetBody: t.snippetBody, .metadata: t.metadata, .badgeNumber: t.badgeNumber,
        .code: t.code, .labelEmphasis: t.labelEmphasis, .chipLabel: t.chipLabel]
    #expect(map.count == BraisenlyTextStyle.allCases.count)
    for style in BraisenlyTextStyle.allCases { #expect(style.font(in: t) == map[style]) }
}
@Test func tonesMapToColorTokens() {
    let c = BraisenlyThemes.solarizedDark.colors
    #expect(BraisenlyTone.accent.color(in: c) == c.accentTeal)
    #expect(BraisenlyTone.danger.color(in: c) == c.danger)
    #expect(BraisenlyTone.secondary.color(in: c) == c.textSecondary)
}
@MainActor @Test(arguments: BraisenlyThemes.all)
func textAndIconRender(theme: BraisenlyThemeDefinition) {
    let dynamic: String = "dynamic"
    #expect(RenderSmoke.renders(VStack { BraisenlyText("Title", style: .vaultTitle); BraisenlyText(dynamic, tone: .secondary)
        BraisenlyIcon(systemName: "star", size: .large, tone: .accent) }, theme: theme, dynamicType: .accessibility5))
}
```
- [ ] **Step 2:** `swift test --filter LayoutTextTests` — Expected: FAIL, "cannot find 'BraisenlyTextStyle'".
- [ ] **Step 3:** Implement the three files (exhaustive `switch` mappings).
- [ ] **Step 4:** `swift test --filter LayoutTextTests` — Expected: PASS.
- [ ] **Step 5:** `git add Sources/BraisenlySwiftUI/Layout/BraisenlyTextStyle.swift Sources/BraisenlySwiftUI/Layout/BraisenlyText.swift Sources/BraisenlySwiftUI/Layout/BraisenlyIcon.swift Tests/BraisenlySwiftUITests/LayoutTextTests.swift && git commit -m "feat(layout): add BraisenlyText and BraisenlyIcon with text-style tokens"`

### Task 13: Layout C — scroll, grid, split view

**Files:**
- Create: `Sources/BraisenlySwiftUI/Layout/BraisenlyScroll.swift`, `BraisenlyGrid.swift`, `BraisenlySplitView.swift`
- Test: `Tests/BraisenlySwiftUITests/LayoutContainerTests.swift`

**Interfaces:**
- Consumes: Task 1, Task 2 `RenderSmoke`.
- Produces (spec §8): `BraisenlyScroll(_ axes: Axis.Set = .vertical, showsIndicators: Bool = true, content:)`; `BraisenlyGrid(minimumColumnWidth: CGFloat = 160, spacing: BraisenlyStep = .m, content:)` (LazyVGrid, `[GridItem(.adaptive(minimum:), spacing:)]`); `BraisenlySplitView(columnVisibility: Binding<NavigationSplitViewVisibility>? = nil, preferredCompactColumn: Binding<NavigationSplitViewColumn>? = nil, extendsDetailBackground: Bool = false, sidebar:, detail:)`. Public stored `axes`, `minimumColumnWidth`, `spacing`, `extendsDetailBackground` for tests.

- [ ] **Step 1: Write the failing test** — stored-property defaults (`BraisenlyScroll { EmptyView() }.axes == .vertical`, `BraisenlyGrid { EmptyView() }.minimumColumnWidth == 160`, `BraisenlySplitView(sidebar: { EmptyView() }, detail: { EmptyView() }).extendsDetailBackground == false`) and a 3-theme render of a split view containing a scroll of a grid of 12 `Text`s at 1024×768.
- [ ] **Step 2:** `swift test --filter LayoutContainerTests` — Expected: FAIL, missing types.
- [ ] **Step 3:** Implement. SplitView: glass theme → plain `NavigationSplitView`; solid → sidebar `.scrollContentBackground(.hidden).background(theme.colors.backgroundDimmed)`, detail `.background(theme.colors.backgroundPrimary)`; nil bindings → `.constant(.automatic)` / `.constant(.sidebar)`; `extendsDetailBackground` → `.backgroundExtensionEffect()` on detail.
- [ ] **Step 4:** `swift test --filter LayoutContainerTests` — Expected: PASS.
- [ ] **Step 5:** `git add Sources/BraisenlySwiftUI/Layout/BraisenlyScroll.swift Sources/BraisenlySwiftUI/Layout/BraisenlyGrid.swift Sources/BraisenlySwiftUI/Layout/BraisenlySplitView.swift Tests/BraisenlySwiftUITests/LayoutContainerTests.swift && git commit -m "feat(layout): add scroll, grid and split-view wrappers"`

---

### Tasks 14–24: Controls (all parallel after Task 2)

Each control task: create `Sources/BraisenlySwiftUI/Controls/<Type>.swift` and `Tests/BraisenlySwiftUITests/<Type>Tests.swift`; consumes Task 1 tokens, Task 2 surfaces/`BraisenlyGlassGroup`/`RenderSmoke`; produces exactly the spec §9 signature; rendering and accessibility per the spec §9 behavior table row. Steps: (1) write the listed tests, (2) `swift test --filter <Type>Tests` expecting "cannot find '<Type>' in scope", (3) implement, (4) rerun expecting PASS, (5) `git add <both files> && git commit -m "feat(controls): add <Type>"`. Every control test includes `@MainActor @Test(arguments: BraisenlyThemes.all) func rendersInEveryTheme(theme:)`.

### Task 14: BraisenlySectionHeader
- Produces: `BraisenlySectionHeader(_ title: String, systemImage: String? = nil, trailing: String? = nil)`; public `let title, systemImage, trailing`.
- Tests: stores args; render in 3 themes.

### Task 15: BraisenlyNavRow
- Produces: `BraisenlyNavRow(title: String, systemImage: String? = nil, badge: String? = nil, isSelected: Bool, platform: BraisenlyPlatform = .automatic, action: @escaping () -> Void)`; public `let title, systemImage, badge, isSelected, platform`.
- Tests: stores args; renders selected and unselected in 3 themes; renders at `.accessibility5` (Review Focus 4).

### Task 16: BraisenlySegmentedControl
- Produces: `BraisenlySegmentedControl<Value: Hashable>(selection: Binding<Value>, options: [Value], title: @escaping (Value) -> String, platform: BraisenlyPlatform = .automatic)`; public `let options`.
- Tests: `options` stored in order; renders with `options: []` (Review Focus 5); renders 3 options in 3 themes and at `.accessibility5`.

### Task 17: BraisenlyToggleRow
- Produces: `BraisenlyToggleRow(_ title: String, subtitle: String? = nil, isOn: Binding<Bool>)`; public `let title, subtitle`.
- Tests: stores args; renders on/off in 3 themes.

### Task 18: BraisenlyStepperRow
- Produces: `BraisenlyStepperRow(_ title: String, value: Binding<Int>, in range: ClosedRange<Int>, step: Int = 1)`; public `let title, range, step`; internal `static func clamped(_ v: Int, to range: ClosedRange<Int>) -> Int`.
- Tests: `clamped(200, to: 0...150) == 150`, `clamped(-1, to: 0...150) == 0`; render in 3 themes.

### Task 19: BraisenlyTextFieldRow
- Produces: `BraisenlyTextFieldRow(_ title: String, text: Binding<String>, prompt: String = "", axis: Axis = .horizontal)`; public `let title, prompt, axis`.
- Tests: defaults (`prompt == ""`, `axis == .horizontal`); renders vertical axis with a 5-line string in 3 themes.

### Task 20: BraisenlyChipGroup + BraisenlyFlowLayout
- Files: also create `Sources/BraisenlySwiftUI/Controls/BraisenlyFlowLayout.swift` (internal).
- Produces: `BraisenlyChipGroup<Value: Hashable>(selection: Binding<Value>, options: [Value], title: @escaping (Value) -> String)`; internal `BraisenlyFlowLayout: Layout { var spacing: CGFloat; static func rows(for sizes: [CGSize], maxWidth: CGFloat, spacing: CGFloat) -> [[Int]] }`.
- Tests:
```swift
@Test func flowPacksGreedily() {
    let s = CGSize(width: 40, height: 20)
    #expect(BraisenlyFlowLayout.rows(for: [s, s, s], maxWidth: 100, spacing: 8) == [[0, 1], [2]])
    #expect(BraisenlyFlowLayout.rows(for: [CGSize(width: 300, height: 20), s], maxWidth: 100, spacing: 8) == [[0], [1]])
    #expect(BraisenlyFlowLayout.rows(for: [], maxWidth: 100, spacing: 8) == [])
}
```
  plus render with `options: []` and with 12 options in 3 themes.

### Task 21: BraisenlyColorSwatch
- Produces: `BraisenlyColorSwatch(color: Color, name: String, detail: String? = nil, isSelected: Bool = false, action: (() -> Void)? = nil)`; public `let name, detail, isSelected`; public computed `isInteractive: Bool { action != nil }`.
- Tests: `isInteractive` false/true; render selected + unselected in 3 themes.

### Task 22: BraisenlyPropertyTable
- Produces: `BraisenlyPropertyTable(rows: [BraisenlyPropertyTable.Row])`; `Row(key: String, value: String)`, `id == key`; public `let rows`.
- Tests: `Row(key: "size", value: "32").id == "size"`; renders `rows: []` and 4 rows in 3 themes.

### Task 23: BraisenlyEmptyState
- Produces: `BraisenlyEmptyState(title: String, message: String? = nil, systemImage: String = "square.dashed", actionTitle: String? = nil, action: (() -> Void)? = nil)`; public `let title, message, systemImage, actionTitle`; `hasAction: Bool { actionTitle != nil && action != nil }`.
- Depends additionally on Task 24 (`BraisenlyButton`) — run after Task 24.
- Tests: `hasAction` false when only one of the pair is set; render both variants in 3 themes.

### Task 24: BraisenlyButton
- Produces: `public enum BraisenlyButtonProminence: Sendable { case standard, prominent }`; `BraisenlyButton(_ title: String, systemImage: String? = nil, prominence: BraisenlyButtonProminence = .standard, action: @escaping () -> Void)`; public `let title, systemImage, prominence`.
- Tests: defaults (`prominence == .standard`); render both prominences in 3 themes and at `.accessibility5`.

---

### Task 25: BraisenlyThemeSwitcher

**Files:**
- Create: `Sources/BraisenlySwiftUI/BraisenlyThemeSwitcher.swift`
- Test: `Tests/BraisenlySwiftUITests/ThemeSwitcherTests.swift`

**Interfaces:**
- Consumes: Task 1 (`BraisenlyThemes.all`, `theme(withID:in:)`, `nextID(after:in:)`), Task 2 (`braisenlyCapsule`, `BraisenlyGlassGroup`, `RenderSmoke`).
- Produces (spec §10): `public enum BraisenlyThemeSwitcherStyle: Sendable, Equatable { case row, cycle }`; `BraisenlyThemeSwitcher(selection: Binding<BraisenlyThemeDefinition.ID>, themes: [BraisenlyThemeDefinition] = BraisenlyThemes.all, style: BraisenlyThemeSwitcherStyle = .row, platform: BraisenlyPlatform = .automatic)`; public `let themes, style, platform`. Accessibility for `.cycle`: label "Theme", value current theme name, hint "Switches to <next theme name>".

- [ ] **Step 1: Write the failing test**

```swift
@Test func defaultsToAllThemesInRowStyle() {
    let s = BraisenlyThemeSwitcher(selection: .constant("liquidGlass"))
    #expect(s.themes.map(\.id) == BraisenlyThemes.all.map(\.id))
    #expect(s.style == .row)
}
@MainActor @Test(arguments: BraisenlyThemes.all)
func rendersBothStylesAndUnknownSelection(theme: BraisenlyThemeDefinition) {
    #expect(RenderSmoke.renders(BraisenlyThemeSwitcher(selection: .constant(theme.id)), theme: theme))
    #expect(RenderSmoke.renders(BraisenlyThemeSwitcher(selection: .constant(theme.id), style: .cycle), theme: theme))
    #expect(RenderSmoke.renders(BraisenlyThemeSwitcher(selection: .constant("nope")), theme: theme))
}
```
- [ ] **Step 2:** `swift test --filter ThemeSwitcherTests` — Expected: FAIL, "cannot find 'BraisenlyThemeSwitcher'".
- [ ] **Step 3:** Implement per spec §10 (`.row` inside `BraisenlyGlassGroup`; `.cycle` single capsule; reduce-motion-gated `withAnimation(.snappy(duration: 0.35))`).
- [ ] **Step 4:** `swift test --filter ThemeSwitcherTests` — Expected: PASS.
- [ ] **Step 5:** `git add Sources/BraisenlySwiftUI/BraisenlyThemeSwitcher.swift Tests/BraisenlySwiftUITests/ThemeSwitcherTests.swift && git commit -m "feat(theme): add BraisenlyThemeSwitcher with row and cycle styles"`

---

### Task 26: Remove legacy theme API (after Tasks 8 and 10)

**Files:**
- Delete: `Sources/BraisenlySwiftUI/BraisenlyTheme.swift`, `Sources/BraisenlySwiftUI/BraisenlyThemeToggle.swift`
- Modify: `Tests/BraisenlySwiftUITests/BraisenlySwiftUITests.swift` (delete `themesToggleBidirectionally`)
- Test: `Tests/BraisenlySwiftUITests/LegacyThemeRemovalTests.swift`

**Interfaces:**
- Consumes: Tasks 8, 10 (no remaining callers of `BraisenlyTheme` / `BraisenlyThemeToggle`).
- Produces: public API without `BraisenlyTheme`, `BraisenlyThemeToggle`, `braisenlyTheme(_: BraisenlyTheme)`.

- [ ] **Step 1: Write the failing test**

```swift
@Test func legacyThemeTypesAreGone() throws {
    let hits = try SourceScan.allSwiftSources().filter { path in
        let text = try! String(contentsOf: SourceScan.root.appending(path: path), encoding: .utf8)
        return text.contains("BraisenlyTheme.") || text.contains("enum BraisenlyTheme:") || text.contains("BraisenlyThemeToggle")
    }
    #expect(hits == [])
}
```
(`SourceScan.root: URL` is the package-root URL from Task 3; if Task 3 kept it private, make it internal in this task.)
- [ ] **Step 2:** `swift test --filter LegacyThemeRemovalTests` — Expected: FAIL listing `Sources/BraisenlySwiftUI/BraisenlyTheme.swift` and `BraisenlyThemeToggle.swift`.
- [ ] **Step 3:** `git rm` both files; delete the old test function.
- [ ] **Step 4:** `swift build && swift test --filter BraisenlySwiftUITests` — Expected: build succeeds, all PASS.
- [ ] **Step 5:** `git add -u Sources/BraisenlySwiftUI/BraisenlyTheme.swift Sources/BraisenlySwiftUI/BraisenlyThemeToggle.swift Tests/BraisenlySwiftUITests/BraisenlySwiftUITests.swift && git add Tests/BraisenlySwiftUITests/LegacyThemeRemovalTests.swift && git commit -m "refactor(theme)!: remove BraisenlyTheme and BraisenlyThemeToggle"`

### Task 27: Repo-wide guards, CHANGELOG 0.2.0, gitignore

**Files:**
- Create: `Tests/BraisenlySwiftUITests/StaticTokenGuardTests.swift`
- Modify: `CHANGELOG.md` (insert spec §13 section above `## 0.1.0`)
- Modify: `.gitignore` (append `.build-*/` for the demo's `.build-symgraph` scratch path, spec §14)

**Interfaces:**
- Consumes: all prior tasks; `SourceScan.allSwiftSources()`, `SourceScan.violations(in:)`, `SourceScan.moduleSources(_:)`, `SourceScan.platformConditionalPublicViolations(in:)`.
- Produces: the regression net for future components (static tokens/literal metrics, and U-16 platform-identical public API).

- [ ] **Step 1: Write the tests**
```swift
@Test func noComponentReadsStaticTokensOrLiteralMetrics() throws {
    #expect(try SourceScan.violations(in: SourceScan.allSwiftSources()) == [])
}

@Test func publicAPIIsIdenticalOnIOSAndMacOS() throws {   // U-16
    #expect(try SourceScan.platformConditionalPublicViolations(in: SourceScan.moduleSources("BraisenlySwiftUI")) == [])
}
```
- [ ] **Step 2:** `swift test --filter StaticTokenGuardTests` — Expected: both PASS if Tasks 1–26 complied; any FAIL names `file:line: <patternID>` or `file:line: platformConditionalPublic` — fix it in that file (move the `public` declaration out of the `#if` region and keep only the body platform-specific) and rerun.
- [ ] **Step 3: Negative check of the U-16 guard (first-class, reported PASS when it fails as declared)** — temporarily append `#if os(macOS)\npublic struct U16Probe {}\n#endif` to `Sources/BraisenlySwiftUI/BraisenlyPlatform.swift`, run `swift test --filter publicAPIIsIdenticalOnIOSAndMacOS`, expect exactly one failure naming `Sources/BraisenlySwiftUI/BraisenlyPlatform.swift:<line>: platformConditionalPublic`, then `git checkout -- Sources/BraisenlySwiftUI/BraisenlyPlatform.swift` and rerun, expecting PASS. Record both results for the run ledger.
- [ ] **Step 4:** Insert the spec §13 CHANGELOG text verbatim. Append `.build-*/` to `.gitignore`, then confirm with `git check-ignore -v .build-symgraph/x` (expected: matches `.gitignore:<n>:.build-*/`).
- [ ] **Step 5:** `swift test` (whole package) — Expected: all suites PASS.
- [ ] **Step 6:** `git add Tests/BraisenlySwiftUITests/StaticTokenGuardTests.swift CHANGELOG.md .gitignore && git commit -m "chore(release): add static-token and platform-identical API guards, 0.2.0 changelog"`

### Task 28: Final verification (no source edits)

**Files:** none (evidence only, recorded in the coordinator's run ledger).

- [ ] **Step 1:** `cd /Volumes/MACDEV/BraisenlySwiftUI-catalog && swift build 2>&1 | tail -5` — Expected: `Build complete!`, zero warnings mentioning `Sendable`, `#available` or `deprecated` in files touched by this plan.
- [ ] **Step 2:** `swift test 2>&1 | tail -15` — Expected: every suite passes; the count includes ThemeResolutionTests, SurfaceModifierTests, SourceScanTests, 7 TokenMigration*Tests, 2 AITokenMigration*Tests, 3 Layout*Tests, 11 control tests, ThemeSwitcherTests, LegacyThemeRemovalTests, StaticTokenGuardTests, plus the pre-existing 5 + 7.
- [ ] **Step 3:** `xcodebuild -scheme BraisenlySwiftUI -destination 'id=00008132-001C383636B9001C' build 2>&1 | tail -5` — Expected: `** BUILD SUCCEEDED **` (presto iPad, iPadOS 27.2; needs USB or a live wireless tunnel — if the device is unreachable, record the exact error and hand to Team B Device Wrangler; do not substitute a simulator).
- [ ] **Step 4:** `xcodebuild -scheme BraisenlySwiftUI -destination 'platform=macOS' build 2>&1 | tail -3` — Expected: `** BUILD SUCCEEDED **`.
- [ ] **Step 5:** `git grep -n "BraisenlyThemeToggle\|BraisenlyTheme\b" -- Sources Tests` — Expected: no output. `git log --oneline development..HEAD` lists one commit per task. Version for the merge is `0.2.0`.

---

## Parallel groups

| group | tasks | starts after |
|---|---|---|
| PG-1 | 1, 3 | — |
| PG-2 | 2 | 1 |
| PG-3 | 4, 5, 6, 7, 9, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 24, 25 | 2 and 3 |
| PG-4 | 8, 10, 23 | 25 (8, 10); 24 (23) |
| PG-5 | 26 | 8 and 10 |
| PG-6 | 27 | all of 4–26 |
| PG-7 | 28 | 27 |
