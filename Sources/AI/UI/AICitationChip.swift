import BraisenlySwiftUI
import SwiftUI

public struct AICitationChip: View {
    public let citation: AICitation

    public init(citation: AICitation) {
        self.citation = citation
    }

    public var body: some View {
        BraisenlyCitationPill(
            title: citation.title,
            source: citation.source,
            url: citation.url
        )
    }
}
