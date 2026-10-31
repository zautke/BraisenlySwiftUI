import SwiftUI

public struct BraisenlySuggestionCard: View {
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
            HStack(spacing: 12) {
                Text(title)
                    .font(BraisenlyDS.Typography.rowLabel)
                    .foregroundStyle(BraisenlyDS.Colors.textPrimary)
                    .multilineTextAlignment(.leading)
                Spacer(minLength: 8)
                if let systemImage {
                    Image(systemName: systemImage)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(BraisenlyDS.Colors.accentTeal)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .frame(maxWidth: 420, minHeight: 44, alignment: .leading)
            .braisenlyCard(cornerRadius: 14)
        }
        .buttonStyle(.plain)
    }
}
