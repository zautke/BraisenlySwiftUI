import SwiftUI
import Testing
@testable import BraisenlySwiftUI

@Suite struct ButtonTests {
    @Test func buttonDefaults() {
        let button = BraisenlyButton("Go") {}
        #expect(button.title == "Go")
        #expect(button.systemImage == nil)
        #expect(button.prominence == .standard)
    }

    @MainActor @Test(arguments: BraisenlyThemes.all)
    func rendersInEveryTheme(theme: BraisenlyThemeDefinition) {
        for prominence in [BraisenlyButtonProminence.standard, .prominent] {
            let view = BraisenlyButton("Go", systemImage: "star", prominence: prominence) {}
            #expect(RenderSmoke.renders(view, theme: theme))
            #expect(RenderSmoke.renders(view, theme: theme, dynamicType: .accessibility5))
        }
    }
}
