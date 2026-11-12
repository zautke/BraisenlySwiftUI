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
    (".padding([.horizontal, .top], 12)", "literalPadding"),
    ("HStack(spacing: 0.5) {", "literalSpacing"),
    (".foregroundStyle(.white)", "colorLiteral"),
    (".fill(.black)", "colorLiteral"),
    ("Color(red: 0.1, green: 0.2, blue: 0.3)", "colorLiteral"),
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
    ("#if os(macOS)\nopen class Y {}\n#endif", 2),
    ("#if canImport(AppKit)\nextension Foo: SomePublicProtocol {}\n#endif", 2),
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

@Test(arguments: [
    ("Sources/BraisenlySwiftUI/BraisenlyDesignSystem.swift", true),
    ("Sources/BraisenlySwiftUI/Theme/BraisenlyTokens.swift", true),
    ("Sources/BraisenlySwiftUI/BraisenlyDesignSystemFoo.swift", false),
    ("Sources/BraisenlySwiftUI/ThemeExtras/X.swift", false),
])
func exemptionMatchesExactFileOrDirectoryOnly(path: String, exempt: Bool) {
    #expect(SourceScan.isExempt(path) == exempt)
}
