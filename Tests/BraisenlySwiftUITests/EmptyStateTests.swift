import SwiftUI
import Testing
@testable import BraisenlySwiftUI

@Suite struct EmptyStateTests {
    @Test func hasActionNeedsBothTitleAndAction() {
        #expect(!BraisenlyEmptyState(title: "None").hasAction)
        #expect(!BraisenlyEmptyState(title: "None", actionTitle: "Add").hasAction)
        #expect(!BraisenlyEmptyState(title: "None", action: {}).hasAction)
        #expect(BraisenlyEmptyState(title: "None", actionTitle: "Add", action: {}).hasAction)
    }

    @Test func defaults() {
        let state = BraisenlyEmptyState(title: "None")
        #expect(state.message == nil)
        #expect(state.systemImage == "square.dashed")
        #expect(state.actionTitle == nil)
    }

    @MainActor @Test(arguments: BraisenlyThemes.all)
    func rendersInEveryTheme(theme: BraisenlyThemeDefinition) {
        #expect(RenderSmoke.renders(BraisenlyEmptyState(title: "None"), theme: theme))
        #expect(RenderSmoke.renders(
            BraisenlyEmptyState(title: "None", message: "Nothing here", systemImage: "tray", actionTitle: "Add", action: {}),
            theme: theme
        ))
    }
}
