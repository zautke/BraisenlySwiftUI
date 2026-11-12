import SwiftUI

private struct BraisenlyPaddingModifier: ViewModifier {
    @Environment(\.braisenlyTheme) private var theme
    let edges: Edge.Set
    let step: BraisenlyStep

    func body(content: Content) -> some View {
        content.padding(edges, theme.metrics.spacing[step])
    }
}

public extension View {
    /// Padding resolved from the environment theme's spacing scale.
    func braisenlyPadding(_ edges: Edge.Set = .all, _ step: BraisenlyStep = .m) -> some View {
        modifier(BraisenlyPaddingModifier(edges: edges, step: step))
    }
}
