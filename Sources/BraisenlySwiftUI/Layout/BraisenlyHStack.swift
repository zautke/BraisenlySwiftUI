import SwiftUI

/// `HStack` whose spacing is a theme step.
public struct BraisenlyHStack<Content: View>: View {
    @Environment(\.braisenlyTheme) private var theme
    public let alignment: VerticalAlignment
    public let spacing: BraisenlyStep
    private let content: Content

    public init(alignment: VerticalAlignment = .center, spacing: BraisenlyStep = .m,
                @ViewBuilder content: () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }

    public var body: some View {
        HStack(alignment: alignment, spacing: theme.metrics.spacing[spacing]) { content }
    }
}
