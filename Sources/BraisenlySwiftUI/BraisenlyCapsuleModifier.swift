import SwiftUI

public struct BraisenlyCapsuleModifier: ViewModifier {
    public let fill: Color

    public init(fill: Color = BraisenlyDS.Colors.surfaceElevated) {
        self.fill = fill
    }

    public func body(content: Content) -> some View {
        content
            .background(Capsule(style: .continuous).fill(fill.opacity(0.94)))
            .overlay(Capsule(style: .continuous).strokeBorder(BraisenlyDS.Colors.borderSubtle))
            .shadow(color: .black.opacity(0.35), radius: 12, x: 0, y: 6)
    }
}

public extension View {
    func braisenlyCapsule(fill: Color = BraisenlyDS.Colors.surfaceElevated) -> some View {
        modifier(BraisenlyCapsuleModifier(fill: fill))
    }
}
