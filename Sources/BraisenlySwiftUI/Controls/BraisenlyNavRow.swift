import SwiftUI

/// Selectable navigation row: icon, title, optional badge capsule.
public struct BraisenlyNavRow: View {
    @Environment(\.braisenlyTheme) private var theme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    public let title: String
    public let systemImage: String?
    public let badge: String?
    public let isSelected: Bool
    public let platform: BraisenlyPlatform
    public let action: () -> Void

    public init(
        title: String,
        systemImage: String? = nil,
        badge: String? = nil,
        isSelected: Bool,
        platform: BraisenlyPlatform = .automatic,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.badge = badge
        self.isSelected = isSelected
        self.platform = platform
        self.action = action
    }

    public var body: some View {
        let resolved = platform.resolved(horizontalSizeClass: horizontalSizeClass)
        Button(action: action) {
            HStack(spacing: theme.metrics.spacing[.m]) {
                if let systemImage {
                    Image(systemName: systemImage)
                        .font(theme.typography.rowIcon)
                        .foregroundStyle(isSelected ? theme.colors.accentTeal : theme.colors.textSecondary)
                        .frame(width: 20)
                        .accessibilityHidden(true)
                }
                Text(title)
                    .font(theme.typography.rowLabel)
                    .foregroundStyle(isSelected ? theme.colors.textBright : theme.colors.textPrimary)
                Spacer(minLength: theme.metrics.spacing[.s])
                if let badge {
                    Text(badge)
                        .font(theme.typography.badgeNumber)
                        .foregroundStyle(theme.colors.textPrimary)
                        .padding(.horizontal, theme.metrics.spacing[.s])
                        .padding(.vertical, theme.metrics.spacing[.xs])
                        .braisenlyCapsule(fill: theme.colors.surfaceHighlight, role: .content)
                }
            }
            .padding(.horizontal, theme.metrics.spacing[.m])
            .padding(.vertical, theme.metrics.spacing[.s])
            .frame(minHeight: resolved.rowHeight)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                if isSelected {
                    RoundedRectangle(cornerRadius: theme.metrics.radius[.s], style: .continuous)
                        .fill(theme.colors.surfaceHighlight)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityValue(badge ?? "")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
