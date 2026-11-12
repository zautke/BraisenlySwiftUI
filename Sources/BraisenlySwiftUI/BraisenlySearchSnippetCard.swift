import SwiftUI

public struct BraisenlySearchSnippetCard: View {
    @Environment(\.braisenlyTheme) private var theme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    public let text: String
    public let query: String
    public let platform: BraisenlyPlatform

    public init(text: String, query: String, platform: BraisenlyPlatform = .automatic) {
        self.text = text
        self.query = query
        self.platform = platform
    }

    public var body: some View {
        let resolvedPlatform = platform.resolved(horizontalSizeClass: horizontalSizeClass)
        BraisenlyHighlightedText(text, highlight: query, font: theme.typography.snippetBody)
            .padding(resolvedPlatform == .mac ? theme.metrics.spacing[.s] : theme.metrics.spacing[.m])
            .frame(maxWidth: .infinity, alignment: .leading)
            .braisenlyCard(cornerRadius: theme.metrics.radius[.s], fill: theme.colors.surfaceSnippet, role: .content)
    }
}
