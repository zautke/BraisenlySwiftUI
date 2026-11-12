import SwiftUI
import Testing
@testable import BraisenlySwiftUI

private let files = [
    "Sources/BraisenlySwiftUI/BraisenlyBottomToolbar.swift",
    "Sources/BraisenlySwiftUI/BraisenlyDocumentActionSheet.swift",
    "Sources/BraisenlySwiftUI/BraisenlyDocumentChrome.swift",
    "Sources/BraisenlySwiftUI/BraisenlyDocumentCanvas.swift",
    "Sources/BraisenlySwiftUI/BraisenlyCompactWorkspace.swift",
    "Sources/BraisenlySwiftUI/BraisenlyRegularWorkspace.swift",
    "Sources/BraisenlySwiftUI/BraisenlyMobileWorkspaceView.swift",
]

@Test func b5FilesHaveNoStaticTokensOrLiteralMetrics() throws {
    #expect(try SourceScan.violations(in: files) == [])
}

@MainActor @Test(arguments: BraisenlyThemes.all)
func b5ViewsRender(theme: BraisenlyThemeDefinition) {
    let id = BraisenlyThemes.liquidGlass.id
    #expect(RenderSmoke.renders(BraisenlyBottomToolbar(), theme: theme))
    #expect(RenderSmoke.renders(BraisenlyDocumentActionSheet(), theme: theme))
    #expect(RenderSmoke.renders(BraisenlyDocumentChrome(), theme: theme))
    #expect(RenderSmoke.renders(
        BraisenlyDocumentCanvas(bodyText: "Body", theme: .constant(id)), theme: theme))
    #expect(RenderSmoke.renders(
        BraisenlyCompactWorkspace(
            documentTitle: "T", documentText: "B", isSidebarOpen: .constant(true),
            isActionSheetPresented: .constant(false), isContextPopoverOpen: .constant(false),
            searchText: .constant(""), selectedMode: .constant(.files), theme: .constant(id)),
        theme: theme))
    #expect(RenderSmoke.renders(
        BraisenlyRegularWorkspace(
            documentTitle: "T", documentText: "B", platform: .iPad,
            isActionSheetPresented: .constant(false), isContextPopoverOpen: .constant(false),
            searchText: .constant(""), selectedMode: .constant(.files), theme: .constant(id)),
        theme: theme))
    #expect(RenderSmoke.renders(BraisenlyMobileWorkspaceView(initialTheme: theme.id), theme: theme))
}

@MainActor @Test func b5UnknownInitialThemeFallsBackToLiquidGlass() {
    #expect(RenderSmoke.renders(BraisenlyMobileWorkspaceView(initialTheme: "nope"), theme: .liquidGlass))
}
