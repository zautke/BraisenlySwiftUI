import SwiftUI

public struct BraisenlyBannerCard: View {
    @Environment(\.braisenlyTheme) private var theme

    public let message: String
    public let systemImage: String
    public let iconColor: Color?
    public let onDismiss: (() -> Void)?

    public init(
        message: String,
        systemImage: String = "exclamationmark.triangle.fill",
        iconColor: Color? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        self.message = message
        self.systemImage = systemImage
        self.iconColor = iconColor
        self.onDismiss = onDismiss
    }

    public var body: some View {
        HStack(spacing: theme.metrics.spacing[.s]) {
            Image(systemName: systemImage)
                .foregroundStyle(iconColor ?? theme.colors.danger)
            Text(message)
                .font(theme.typography.metadata)
                .foregroundStyle(theme.colors.textPrimary)
            Spacer()
            if let onDismiss {
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .foregroundStyle(theme.colors.textSecondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Dismiss banner")
            }
        }
        .padding(theme.metrics.spacing[.m])
        .braisenlyCard(cornerRadius: theme.metrics.radius[.s], fill: theme.colors.surfaceSnippet, role: .content)
    }
}
