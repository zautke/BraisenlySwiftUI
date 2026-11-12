import SwiftUI
import Testing
@testable import BraisenlySwiftUI

private let files = [
    "Sources/BraisenlySwiftUI/BraisenlyActionRow.swift",
    "Sources/BraisenlySwiftUI/BraisenlyActionGroup.swift",
    "Sources/BraisenlySwiftUI/BraisenlyExpandableSearchResult.swift",
    "Sources/BraisenlySwiftUI/BraisenlySidebarSearchHeader.swift",
    "Sources/BraisenlySwiftUI/BraisenlySidebarFooter.swift",
    "Sources/BraisenlySwiftUI/BraisenlySidebarContextPopover.swift",
    "Sources/BraisenlySwiftUI/BraisenlySidebarDrawer.swift",
]

@Test func b4FilesHaveNoStaticTokensOrLiteralMetrics() throws {
    #expect(try SourceScan.violations(in: files) == [])
}

@MainActor @Test(arguments: BraisenlyThemes.all)
func b4ViewsRender(theme: BraisenlyThemeDefinition) {
    let item = BraisenlyActionItem(id: "a", icon: "star", title: "Action", isChecked: true)
    #expect(RenderSmoke.renders(BraisenlyActionRow(item: item), theme: theme))
    #expect(RenderSmoke.renders(BraisenlyActionGroup(items: [item, item]) { _ in }, theme: theme))
    #expect(RenderSmoke.renders(
        BraisenlyExpandableSearchResult(query: "q", isExpanded: .constant(true)), theme: theme))
    #expect(RenderSmoke.renders(BraisenlySidebarSearchHeader(searchText: .constant("")), theme: theme))
    #expect(RenderSmoke.renders(BraisenlySidebarFooter(selectedMode: .files) {}, theme: theme))
    #expect(RenderSmoke.renders(
        BraisenlySidebarContextPopover(selectedMode: .constant(.files), isPresented: .constant(true)),
        theme: theme))
    #expect(RenderSmoke.renders(
        BraisenlySidebarDrawer(
            searchText: .constant("a"), selectedMode: .constant(.files),
            isShowingContextPopover: .constant(true)),
        theme: theme))
}
