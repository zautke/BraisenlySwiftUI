import SwiftUI
import Testing
@testable import BraisenlySwiftUI

@Suite struct BraisenlyNavRowTests {
    @Test func navRowStoresArguments() {
        let row = BraisenlyNavRow(title: "Chats", systemImage: "bubble.left", badge: "4", isSelected: true, platform: .mac) {}
        #expect(row.title == "Chats")
        #expect(row.systemImage == "bubble.left")
        #expect(row.badge == "4")
        #expect(row.isSelected)
        #expect(row.platform == .mac)
        #expect(BraisenlyNavRow(title: "X", isSelected: false) {}.platform == .automatic)
    }

    @MainActor @Test(arguments: BraisenlyThemes.all)
    func rendersInEveryTheme(theme: BraisenlyThemeDefinition) {
        #expect(RenderSmoke.renders(BraisenlyNavRow(title: "Chats", systemImage: "bubble.left", badge: "4", isSelected: true) {}, theme: theme))
        #expect(RenderSmoke.renders(BraisenlyNavRow(title: "Chats", isSelected: false) {}, theme: theme))
    }

    @MainActor @Test(arguments: BraisenlyThemes.all)
    func rendersAtAccessibility5(theme: BraisenlyThemeDefinition) {
        #expect(RenderSmoke.renders(
            BraisenlyNavRow(title: "A long navigation title", systemImage: "bubble.left", badge: "12", isSelected: true) {},
            theme: theme, dynamicType: .accessibility5))
    }
}
