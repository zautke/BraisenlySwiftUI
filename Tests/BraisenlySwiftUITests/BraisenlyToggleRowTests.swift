import SwiftUI
import Testing
@testable import BraisenlySwiftUI

@Suite struct BraisenlyToggleRowTests {
    @Test func toggleRowStoresArguments() {
        let row = BraisenlyToggleRow("Streaming", subtitle: "Token by token", isOn: .constant(true))
        #expect(row.title == "Streaming")
        #expect(row.subtitle == "Token by token")
        #expect(BraisenlyToggleRow("X", isOn: .constant(false)).subtitle == nil)
    }

    @MainActor @Test(arguments: BraisenlyThemes.all)
    func rendersInEveryTheme(theme: BraisenlyThemeDefinition) {
        #expect(RenderSmoke.renders(BraisenlyToggleRow("Streaming", subtitle: "Token by token", isOn: .constant(true)), theme: theme))
        #expect(RenderSmoke.renders(BraisenlyToggleRow("Streaming", isOn: .constant(false)), theme: theme))
    }
}
