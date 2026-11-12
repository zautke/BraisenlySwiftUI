import SwiftUI

public struct BraisenlyDualActionPill: View {
    @Environment(\.braisenlyTheme) private var theme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    public let platform: BraisenlyPlatform
    public let onEdit: () -> Void
    public let onMore: () -> Void

    public init(
        platform: BraisenlyPlatform = .automatic,
        onEdit: @escaping () -> Void,
        onMore: @escaping () -> Void
    ) {
        self.platform = platform
        self.onEdit = onEdit
        self.onMore = onMore
    }

    public var body: some View {
        let size = platform.resolved(horizontalSizeClass: horizontalSizeClass).controlSize
        HStack(spacing: 0) {
            Button(action: onEdit) { Image(systemName: "pencil").frame(width: size, height: size) }
                .accessibilityLabel("Edit")
            Button(action: onMore) { Image(systemName: "ellipsis").frame(width: size, height: size) }
                .accessibilityLabel("More actions")
        }
        .font(theme.typography.controlIcon)
        .foregroundStyle(theme.colors.textPrimary)
        .buttonStyle(.plain)
        .braisenlyCapsule()
    }
}
