import SwiftUI

public struct BraisenlyAvatarBadge: View {
    public let systemName: String
    public let foregroundColor: Color
    public let backgroundColor: Color
    public let borderColor: Color
    public let size: CGFloat
    public let iconSize: CGFloat

    public init(
        systemName: String,
        foregroundColor: Color = BraisenlyDS.Colors.accentTeal,
        backgroundColor: Color = BraisenlyDS.Colors.surfaceElevated,
        borderColor: Color = BraisenlyDS.Colors.borderSubtle,
        size: CGFloat = 32,
        iconSize: CGFloat = 14
    ) {
        self.systemName = systemName
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.size = size
        self.iconSize = iconSize
    }

    public var body: some View {
        Image(systemName: systemName)
            .font(.system(size: iconSize, weight: .semibold))
            .foregroundStyle(foregroundColor)
            .frame(width: size, height: size)
            .background(Circle().fill(backgroundColor))
            .overlay(Circle().strokeBorder(borderColor))
            .accessibilityHidden(true)
    }
}
