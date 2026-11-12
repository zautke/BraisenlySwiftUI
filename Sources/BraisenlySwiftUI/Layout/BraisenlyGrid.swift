import SwiftUI

/// Adaptive `LazyVGrid`; spacing is a theme step.
public struct BraisenlyGrid<Content: View>: View {
    @Environment(\.braisenlyTheme) private var theme
    public let minimumColumnWidth: CGFloat
    public let spacing: BraisenlyStep
    private let content: Content

    public init(minimumColumnWidth: CGFloat = 160, spacing: BraisenlyStep = .m,
                @ViewBuilder content: () -> Content) {
        self.minimumColumnWidth = minimumColumnWidth
        self.spacing = spacing
        self.content = content()
    }

    public var body: some View {
        let gap = theme.metrics.spacing[spacing]
        LazyVGrid(columns: [GridItem(.adaptive(minimum: minimumColumnWidth), spacing: gap)], spacing: gap) {
            content
        }
    }
}
