import SwiftUI

public struct BraisenlyCitationPill: View {
    @Environment(\.braisenlyTheme) private var theme

    public let title: String
    public let source: String?
    public let url: URL?
    public let systemImage: String

    public init(
        title: String,
        source: String? = nil,
        url: URL? = nil,
        systemImage: String = "link"
    ) {
        self.title = title
        self.source = source
        self.url = url
        self.systemImage = systemImage
    }

    public var body: some View {
        if let url {
            Link(destination: url) { pillContent }
                .buttonStyle(.plain)
        } else {
            pillContent
        }
    }

    private var pillContent: some View {
        HStack(spacing: theme.metrics.spacing[.s]) {
            Image(systemName: systemImage)
                .font(theme.typography.chipLabel)
            Text(displayTitle)
                .font(theme.typography.metadata)
                .lineLimit(1)
        }
        .foregroundStyle(theme.colors.accentTeal)
        .padding(.horizontal, theme.metrics.spacing[.s])
        .padding(.vertical, theme.metrics.spacing[.s])
        .braisenlyCapsule(fill: theme.colors.surfaceSnippet)
    }

    private var displayTitle: String {
        if let source, !source.isEmpty {
            return "\(title) · \(source)"
        }
        return title
    }
}
