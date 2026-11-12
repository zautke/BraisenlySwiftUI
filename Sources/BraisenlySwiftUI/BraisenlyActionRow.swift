import SwiftUI

public struct BraisenlyActionRow: View {
    @Environment(\.braisenlyTheme) private var theme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    public let item: BraisenlyActionItem
    public let platform: BraisenlyPlatform

    public init(item: BraisenlyActionItem, platform: BraisenlyPlatform = .automatic) {
        self.item = item
        self.platform = platform
    }

    public var body: some View {
        let resolvedPlatform = platform.resolved(horizontalSizeClass: horizontalSizeClass)
        HStack(spacing: theme.metrics.spacing[.m]) {
            Image(systemName: item.icon).frame(width: 22)
            Text(item.title)
            Spacer()
            if item.isChecked { Image(systemName: "checkmark").fontWeight(.semibold) }
        }
        .font(theme.typography.rowLabel)
        .foregroundStyle(theme.colors.textPrimary)
        .padding(.horizontal, theme.metrics.spacing[.l])
        .frame(minHeight: resolvedPlatform.rowHeight)
        .contentShape(Rectangle())
    }
}
