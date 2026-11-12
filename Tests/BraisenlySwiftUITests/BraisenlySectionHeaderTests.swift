import SwiftUI
import Testing
@testable import BraisenlySwiftUI

@Suite struct BraisenlySectionHeaderTests {
    @Test func sectionHeaderStoresArguments() {
        let header = BraisenlySectionHeader("Models", systemImage: "cpu", trailing: "3")
        #expect(header.title == "Models")
        #expect(header.systemImage == "cpu")
        #expect(header.trailing == "3")
        #expect(BraisenlySectionHeader("X").systemImage == nil)
    }

    @MainActor @Test(arguments: BraisenlyThemes.all)
    func rendersInEveryTheme(theme: BraisenlyThemeDefinition) {
        #expect(RenderSmoke.renders(BraisenlySectionHeader("Models", systemImage: "cpu", trailing: "3"), theme: theme))
    }
}
