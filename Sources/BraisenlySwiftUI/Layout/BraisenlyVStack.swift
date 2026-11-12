import SwiftUI

/// `VStack` whose spacing is a theme step.
public struct BraisenlyVStack<Content: View>: View {
    @Environment(\.braisenlyTheme) private var theme
    public let alignment: HorizontalAlignment
    public let spacing: BraisenlyStep
    private let content: Content

    public init(alignment: HorizontalAlignment = .center, spacing: BraisenlyStep = .m,
                @ViewBuilder content: () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: alignment, spacing: theme.metrics.spacing[spacing]) { content }
    }
}
