import SwiftUI
import Testing
@testable import BraisenlySwiftUI

@Suite struct BraisenlyPropertyTableTests {
    @Test func rowIdIsKey() {
        #expect(BraisenlyPropertyTable.Row(key: "size", value: "32").id == "size")
    }

    @MainActor @Test(arguments: BraisenlyThemes.all)
    func rendersInEveryTheme(theme: BraisenlyThemeDefinition) {
        let rows = ["size", "radius", "weight", "tint"].map { BraisenlyPropertyTable.Row(key: $0, value: "v") }
        #expect(RenderSmoke.renders(BraisenlyPropertyTable(rows: rows), theme: theme))
        #expect(RenderSmoke.renders(BraisenlyPropertyTable(rows: []), theme: theme))
    }
}
