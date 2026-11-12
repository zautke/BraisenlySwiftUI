import SwiftUI

public struct BraisenlySuggestionCard: View {
    @Environment(\.braisenlyTheme) private var theme

    public let title: String
    public let systemImage: String?
    public let action: () -> Void

    public init(
        title: String,
        systemImage: String? = "arrow.up.right",
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: theme.metrics.spacing[.m]) {
                Text(title)
                    .font(theme.typography.rowLabel)
                    .foregroundStyle(theme.colors.textPrimary)
                    .multilineTextAlignment(.leading)
                Spacer(minLength: theme.metrics.spacing[.s])
                if let systemImage {
                    Image(systemName: systemImage)
                        .font(theme.typography.labelEmphasis)
                        .foregroundStyle(theme.colors.accentTeal)
                }
            }
            .padding(.horizontal, theme.metrics.spacing[.l])
            .padding(.vertical, theme.metrics.spacing[.s])
            .frame(maxWidth: 420, minHeight: theme.metrics.circleButtonSize, alignment: .leading)
            .braisenlyCard(cornerRadius: theme.metrics.radius[.m], role: .content)
        }
        .buttonStyle(.plain)
    }
}
