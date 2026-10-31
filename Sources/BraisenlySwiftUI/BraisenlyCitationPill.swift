import SwiftUI

public struct BraisenlyCitationPill: View {
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
        HStack(spacing: 6) {
            Image(systemName: systemImage)
                .font(.system(size: 11, weight: .semibold))
            Text(displayTitle)
                .font(BraisenlyDS.Typography.metadata)
                .lineLimit(1)
        }
        .foregroundStyle(BraisenlyDS.Colors.accentTeal)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .braisenlyCapsule(fill: BraisenlyDS.Colors.surfaceSnippet)
    }

    private var displayTitle: String {
        if let source, !source.isEmpty {
            return "\(title) · \(source)"
        }
        return title
    }
}
