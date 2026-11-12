import SwiftUI
import Testing
@testable import BraisenlySwiftUI

private let files = [
    "Sources/BraisenlySwiftUI/BraisenlyBannerCard.swift",
    "Sources/BraisenlySwiftUI/BraisenlyStatusCard.swift",
    "Sources/BraisenlySwiftUI/BraisenlySuggestionCard.swift",
    "Sources/BraisenlySwiftUI/BraisenlyCodeBlockCard.swift",
    "Sources/BraisenlySwiftUI/BraisenlyChatBubbleSurface.swift",
    "Sources/BraisenlySwiftUI/BraisenlySearchSnippetCard.swift",
    "Sources/BraisenlySwiftUI/BraisenlyConversationRow.swift",
    "Sources/BraisenlySwiftUI/BraisenlySearchMetadataRow.swift",
]

@Test func b3FilesHaveNoStaticTokensOrLiteralMetrics() throws {
    #expect(try SourceScan.violations(in: files) == [])
}

@MainActor @Test(arguments: BraisenlyThemes.all)
func b3ViewsRender(theme: BraisenlyThemeDefinition) {
    #expect(RenderSmoke.renders(BraisenlyBannerCard(message: "m", onDismiss: {}), theme: theme))
    #expect(RenderSmoke.renders(BraisenlyStatusCard(title: "t", subtitle: "s", systemImage: "star"), theme: theme))
    #expect(RenderSmoke.renders(BraisenlySuggestionCard(title: "t", action: {}), theme: theme))
    #expect(RenderSmoke.renders(BraisenlyCodeBlockCard(language: "swift", code: "let x = 1", onCopy: {}), theme: theme))
    #expect(RenderSmoke.renders(BraisenlyChatBubbleSurface(text: "hi **there**"), theme: theme))
    #expect(RenderSmoke.renders(BraisenlySearchSnippetCard(text: "hello world", query: "world"), theme: theme))
    #expect(RenderSmoke.renders(BraisenlyConversationRow(title: "t", subtitle: "s", timestampText: "now", isSelected: true, action: {}), theme: theme))
    #expect(RenderSmoke.renders(BraisenlySearchMetadataRow(), theme: theme))
}

@Test func b3OptionalOverridesDefaultToNil() {
    #expect(BraisenlyChatBubbleSurface(text: "x").cornerRadius == nil)
    #expect(BraisenlyChatBubbleSurface(text: "x").fill == nil)
    #expect(BraisenlyBannerCard(message: "x").iconColor == nil)
    #expect(BraisenlyStatusCard(title: "x", systemImage: "star").iconColor == nil)
}
