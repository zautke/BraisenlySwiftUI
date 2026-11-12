import SwiftUI

public struct BraisenlyConversationRow: View {
    @Environment(\.braisenlyTheme) private var theme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    public let title: String
    public let subtitle: String?
    public let timestampText: String?
    public let isSelected: Bool
    public let isPinned: Bool
    public let platform: BraisenlyPlatform
    public let action: () -> Void

    public init(
        title: String,
        subtitle: String? = nil,
        timestampText: String? = nil,
        isSelected: Bool = false,
        isPinned: Bool = false,
        platform: BraisenlyPlatform = .automatic,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.timestampText = timestampText
        self.isSelected = isSelected
        self.isPinned = isPinned
        self.platform = platform
        self.action = action
    }

    public var body: some View {
        let resolvedPlatform = platform.resolved(horizontalSizeClass: horizontalSizeClass)
        Button(action: action) {
            HStack(spacing: theme.metrics.spacing[.m]) {
                Image(systemName: isPinned ? "pin.fill" : "bubble.left.and.bubble.right")
                    .font(theme.typography.rowIcon)
                    .foregroundStyle(isSelected ? theme.colors.accentTeal : theme.colors.textSecondary)
                    .frame(width: 20)
                VStack(alignment: .leading, spacing: theme.metrics.spacing[.xs]) {
                    Text(title)
                        .font(theme.typography.rowLabelMedium)
                        .foregroundStyle(isSelected ? theme.colors.textBright : theme.colors.textPrimary)
                        .lineLimit(1)
                    if let subtitle, !subtitle.isEmpty {
                        Text(subtitle)
                            .font(theme.typography.metadata)
                            .foregroundStyle(theme.colors.textSecondary)
                            .lineLimit(1)
                    }
                }
                Spacer(minLength: theme.metrics.spacing[.s])
                if let timestampText {
                    Text(timestampText)
                        .font(theme.typography.metadata)
                        .foregroundStyle(theme.colors.textSecondary)
                }
            }
            .padding(.horizontal, theme.metrics.spacing[.m])
            .padding(.vertical, theme.metrics.spacing[.s])
            .frame(minHeight: resolvedPlatform.rowHeight)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                if isSelected {
                    RoundedRectangle(cornerRadius: theme.metrics.radius[.m], style: .continuous)
                        .fill(theme.colors.surfaceHighlight.opacity(0.45))
                }
            }
            .overlay {
                if isSelected {
                    RoundedRectangle(cornerRadius: theme.metrics.radius[.m], style: .continuous)
                        .strokeBorder(theme.colors.accentTeal.opacity(0.6), lineWidth: theme.metrics.hairline * 2)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
