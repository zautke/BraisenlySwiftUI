import BraisenlySwiftUI
import SwiftUI

public struct AICitationChip: View {
    public let citation: AICitation

    public init(citation: AICitation) {
        self.citation = citation
    }

    public var body: some View {
        if let url = citation.url {
            Link(destination: url) { label }
                .buttonStyle(.plain)
        } else {
            label
        }
    }

    private var label: some View {
        Label(citation.title, systemImage: "link")
            .font(BraisenlyDS.Typography.metadata)
            .foregroundStyle(BraisenlyDS.Colors.accentTeal)
            .lineLimit(1)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .braisenlyCapsule(fill: BraisenlyDS.Colors.surfaceSnippet)
    }
}
