import SwiftUI

public struct BraisenlyStatusCard: View {
    @Environment(\.braisenlyTheme) private var theme

    public let title: String
    public let subtitle: String
    public let systemImage: String
    public let iconColor: Color?

    public init(
        title: String,
        subtitle: String = "",
        systemImage: String,
        iconColor: Color? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.systemImage = systemImage
        self.iconColor = iconColor
    }

    public var body: some View {
        HStack(alignment: .top, spacing: theme.metrics.spacing[.s]) {
            Image(systemName: systemImage)
                .foregroundStyle(iconColor ?? theme.colors.accentTeal)
                .frame(width: 20)
            VStack(alignment: .leading, spacing: theme.metrics.spacing[.xs]) {
                Text(title)
                    .font(theme.typography.rowLabelMedium)
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(theme.typography.metadata)
                        .foregroundStyle(theme.colors.textSecondary)
                }
            }
            Spacer(minLength: 0)
        }
        .foregroundStyle(theme.colors.textPrimary)
        .padding(theme.metrics.spacing[.m])
        .braisenlyCard(
            cornerRadius: theme.metrics.radius[.s],
            fill: theme.colors.surfaceSnippet,
            role: .content
        )
        .accessibilityElement(children: .combine)
    }
}
