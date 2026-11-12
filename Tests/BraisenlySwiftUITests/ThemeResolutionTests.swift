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
