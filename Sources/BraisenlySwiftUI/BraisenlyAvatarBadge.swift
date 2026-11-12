import SwiftUI

public struct BraisenlyAvatarBadge: View {
    @Environment(\.braisenlyTheme) private var theme
    @ScaledMetric(relativeTo: .body) private var iconScale: CGFloat = 1

    public let systemName: String
    /// nil = `theme.colors.accentTeal`.
    public let foregroundColor: Color?
    /// nil = `theme.colors.surfaceElevated`.
    public let backgroundColor: Color?
    /// nil = `theme.colors.borderSubtle`.
    public let borderColor: Color?
    public let size: CGFloat
    public let iconSize: CGFloat

    public init(
        systemName: String,
        foregroundColor: Color? = nil,
        backgroundColor: Color? = nil,
        borderColor: Color? = nil,
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
            .font(.system(size: iconSize * iconScale, weight: .semibold))
            .foregroundStyle(foregroundColor ?? theme.colors.accentTeal)
            .frame(width: size, height: size)
            .background(Circle().fill(backgroundColor ?? theme.colors.surfaceElevated))
            .overlay(Circle().strokeBorder(borderColor ?? theme.colors.borderSubtle))
            .accessibilityHidden(true)
    }
}
