import SwiftUI
import Testing
@testable import BraisenlySwiftUI

@Suite struct BraisenlyColorSwatchTests {
    @Test func isInteractiveFollowsAction() {
        #expect(BraisenlyColorSwatch(color: .red, name: "Red").isInteractive == false)
        #expect(BraisenlyColorSwatch(color: .red, name: "Red", action: {}).isInteractive == true)
    }

    @MainActor @Test(arguments: BraisenlyThemes.all)
    func rendersInEveryTheme(theme: BraisenlyThemeDefinition) {
        let view = VStack {
            BraisenlyColorSwatch(color: .red, name: "Red", detail: "#FF0000", isSelected: true, action: {})
            BraisenlyColorSwatch(color: .blue, name: "Blue")
        }
        #expect(RenderSmoke.renders(view, theme: theme))
    }
}
