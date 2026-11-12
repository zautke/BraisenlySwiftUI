import SwiftUI

public struct BraisenlyCircleIconButton: View {
    @Environment(\.braisenlyTheme) private var theme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @ScaledMetric(relativeTo: .body) private var iconScale: CGFloat = 1

    public let systemName: String
    public let accessibilityLabel: LocalizedStringResource
    public let iconSize: CGFloat
    public let platform: BraisenlyPlatform
    public let action: () -> Void

    public init(
        systemName: String,
        accessibilityLabel: LocalizedStringResource,
        iconSize: CGFloat = 18,
        platform: BraisenlyPlatform = .automatic,
        action: @escaping () -> Void
    ) {
        self.systemName = systemName
        self.accessibilityLabel = accessibilityLabel
        self.iconSize = iconSize
        self.platform = platform
        self.action = action
    }

    public var body: some View {
        let resolvedPlatform = platform.resolved(horizontalSizeClass: horizontalSizeClass)
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: iconSize * iconScale, weight: .medium))
                .foregroundStyle(theme.colors.textPrimary)
                .frame(width: resolvedPlatform.controlSize, height: resolvedPlatform.controlSize)
                .braisenlyCapsule()
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(accessibilityLabel))
    }
}
