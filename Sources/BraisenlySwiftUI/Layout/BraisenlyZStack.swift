import SwiftUI

/// Plain `ZStack` wrapper.
public struct BraisenlyZStack<Content: View>: View {
    public let alignment: Alignment
    private let content: Content

    public init(alignment: Alignment = .center, @ViewBuilder content: () -> Content) {
        self.alignment = alignment
        self.content = content()
    }

    public var body: some View {
        ZStack(alignment: alignment) { content }
    }
}
