import SwiftUI

/// Plain `ScrollView` wrapper.
public struct BraisenlyScroll<Content: View>: View {
    public let axes: Axis.Set
    public let showsIndicators: Bool
    private let content: Content

    public init(_ axes: Axis.Set = .vertical, showsIndicators: Bool = true,
                @ViewBuilder content: () -> Content) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.content = content()
    }

    public var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) { content }
    }
}
