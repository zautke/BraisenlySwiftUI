import SwiftUI

public struct BraisenlyBannerCard: View {
    public let message: String
    public let systemImage: String
    public let iconColor: Color
    public let onDismiss: (() -> Void)?

    public init(
        message: String,
        systemImage: String = "exclamationmark.triangle.fill",
        iconColor: Color = BraisenlyDS.Solarized.red,
        onDismiss: (() -> Void)? = nil
    ) {
        self.message = message
        self.systemImage = systemImage
        self.iconColor = iconColor
        self.onDismiss = onDismiss
    }

    public var body: some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
                .foregroundStyle(iconColor)
            Text(message)
                .font(BraisenlyDS.Typography.metadata)
                .foregroundStyle(BraisenlyDS.Colors.textPrimary)
            Spacer()
            if let onDismiss {
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .foregroundStyle(BraisenlyDS.Colors.textSecondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Dismiss banner")
            }
        }
        .padding(12)
        .braisenlyCard(cornerRadius: 12, fill: BraisenlyDS.Colors.surfaceSnippet)
    }
}
