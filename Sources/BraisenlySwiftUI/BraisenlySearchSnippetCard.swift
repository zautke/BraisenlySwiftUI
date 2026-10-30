import SwiftUI

public struct BraisenlySearchSnippetCard: View {
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
        BraisenlyHighlightedText(text, highlight: query, font: BraisenlyDS.Typography.snippetBody)
            .padding(resolvedPlatform == .mac ? 10 : 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .braisenlyCard(cornerRadius: BraisenlyDS.Metrics.snippetRadius, fill: BraisenlyDS.Colors.surfaceSnippet)
    }
}
