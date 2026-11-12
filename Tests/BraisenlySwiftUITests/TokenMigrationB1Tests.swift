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
    #expect(try SourceScan.violations(in: files) == [])
}

@MainActor @Test(arguments: BraisenlyThemes.all)
func b1ViewsRender(theme: BraisenlyThemeDefinition) {
    let view = VStack {
        BraisenlyCircleIconButton(systemName: "plus", accessibilityLabel: "Add") {}
        BraisenlyToolbarIconButton(systemName: "gear", label: "Settings") {}
        BraisenlyToolbarIconButton(systemName: "gear", label: "Settings", isEnabled: false) {}
        BraisenlySendStopButton(isResponding: false, canSend: true, onSend: {}, onCancel: {})
        BraisenlySendStopButton(isResponding: true, canSend: false, onSend: {}, onCancel: {})
        BraisenlyDualActionPill(onEdit: {}, onMore: {})
        BraisenlyMessageActionPill(isCopied: true, canRegenerate: true, onCopy: {}, onRegenerate: {})
        BraisenlyModelPill(title: "Model")
        BraisenlyModelPill(title: "Model", action: {})
        BraisenlyCitationPill(title: "Title", source: "Source")
        BraisenlyCitationPill(title: "Title", url: URL(string: "https://example.com"))
    }
    #expect(RenderSmoke.renders(view, theme: theme))
}
