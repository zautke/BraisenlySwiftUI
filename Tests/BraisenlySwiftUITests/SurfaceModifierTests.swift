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
