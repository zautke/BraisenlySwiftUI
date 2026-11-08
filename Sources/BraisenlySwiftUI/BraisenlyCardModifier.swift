import SwiftUI

public struct BraisenlyCardModifier: ViewModifier {
    public let cornerRadius: CGFloat
    public let fill: Color

    public init(
        cornerRadius: CGFloat = BraisenlyDS.Metrics.cardRadius,
        fill: Color = BraisenlyDS.Colors.surfaceElevated
    ) {
        self.cornerRadius = cornerRadius
        self.fill = fill
    }

    public func body(content: Content) -> some View {
        content
            .background(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous).fill(fill))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(BraisenlyDS.Colors.borderSubtle.opacity(0.6), lineWidth: 0.8)
            )
    }
}

public extension View {
    func braisenlyCard(
        cornerRadius: CGFloat = BraisenlyDS.Metrics.cardRadius,
        fill: Color = BraisenlyDS.Colors.surfaceElevated
    ) -> some View {
        modifier(BraisenlyCardModifier(cornerRadius: cornerRadius, fill: fill))
    }
}
