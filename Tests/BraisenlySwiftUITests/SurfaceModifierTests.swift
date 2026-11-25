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

@MainActor @Test(arguments: BraisenlyThemes.all)
func glassGroupMarksDescendants(theme: BraisenlyThemeDefinition) {
    var seen: Bool?
    let probe = BraisenlyGlassGroup { EnvironmentReader { seen = $0.braisenlyIsInGlassGroup } }
    _ = RenderSmoke.renders(probe, theme: theme)
    #expect(seen == true) // container always present (inert without glass children) so theme switches keep structure
}

@MainActor @Test func nestedGlassGroupStillMarksDescendants() {
    var seen: Bool?
    let probe = BraisenlyGlassGroup { BraisenlyGlassGroup { EnvironmentReader { seen = $0.braisenlyIsInGlassGroup } } }
    _ = RenderSmoke.renders(probe, theme: .liquidGlass)
    #expect(seen == true)
}

@Suite struct SelectedContrastTests {
    private static func luminance(_ color: Color) -> Double {
        let c = color.resolve(in: EnvironmentValues())
        return 0.2126 * Double(c.linearRed) + 0.7152 * Double(c.linearGreen) + 0.0722 * Double(c.linearBlue)
    }

    static func ratio(_ a: Color, _ b: Color) -> Double {
        let (hi, lo) = (max(luminance(a), luminance(b)), min(luminance(a), luminance(b)))
        return (hi + 0.05) / (lo + 0.05)
    }

    @Test(arguments: [BraisenlyThemes.solarizedLight, BraisenlyThemes.solarizedDark])
    func selectedLabelContrastsWithSelectedFill(theme: BraisenlyThemeDefinition) {
        let pair = theme.selectedPair
        #expect(Self.ratio(pair.label, pair.fill) >= 4.5)
    }
}
