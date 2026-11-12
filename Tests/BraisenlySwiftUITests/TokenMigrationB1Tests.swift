import SwiftUI
import Testing
@testable import BraisenlySwiftUI

private let files = [
    "Sources/BraisenlySwiftUI/BraisenlyCircleIconButton.swift",
    "Sources/BraisenlySwiftUI/BraisenlyToolbarIconButton.swift",
    "Sources/BraisenlySwiftUI/BraisenlySendStopButton.swift",
    "Sources/BraisenlySwiftUI/BraisenlyDualActionPill.swift",
    "Sources/BraisenlySwiftUI/BraisenlyMessageActionPill.swift",
    "Sources/BraisenlySwiftUI/BraisenlyModelPill.swift",
    "Sources/BraisenlySwiftUI/BraisenlyCitationPill.swift",
]

@Test func b1FilesHaveNoStaticTokensOrLiteralMetrics() throws {
    let v = try SourceScan.violations(in: files)
    #expect(v == [], "\(v)")
}

@MainActor @Test(arguments: BraisenlyThemes.all)
func b1ViewsRender(theme: BraisenlyThemeDefinition) {
    #expect(RenderSmoke.renders(BraisenlyCircleIconButton(systemName: "plus", accessibilityLabel: "Add") {}, theme: theme))
    #expect(RenderSmoke.renders(BraisenlyToolbarIconButton(systemName: "gear", label: "Settings") {}, theme: theme))
    #expect(RenderSmoke.renders(BraisenlyToolbarIconButton(systemName: "gear", label: "Settings", isEnabled: false) {}, theme: theme))
    #expect(RenderSmoke.renders(BraisenlySendStopButton(isResponding: false, canSend: true, onSend: {}, onCancel: {}), theme: theme))
    #expect(RenderSmoke.renders(BraisenlySendStopButton(isResponding: true, canSend: false, onSend: {}, onCancel: {}), theme: theme))
    #expect(RenderSmoke.renders(BraisenlyDualActionPill(onEdit: {}, onMore: {}), theme: theme))
    #expect(RenderSmoke.renders(BraisenlyMessageActionPill(isCopied: true, canRegenerate: true, onCopy: {}, onRegenerate: {}), theme: theme))
    #expect(RenderSmoke.renders(BraisenlyModelPill(title: "Model"), theme: theme))
    #expect(RenderSmoke.renders(BraisenlyModelPill(title: "Model", action: {}), theme: theme))
    #expect(RenderSmoke.renders(BraisenlyCitationPill(title: "Title", source: "Source"), theme: theme))
    #expect(RenderSmoke.renders(BraisenlyCitationPill(title: "Title", url: URL(string: "https://example.com")), theme: theme))
}
