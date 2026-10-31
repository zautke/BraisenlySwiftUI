import SwiftUI

public struct BraisenlyConversationRow: View {
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
            HStack(spacing: 12) {
                Image(systemName: isPinned ? "pin.fill" : "bubble.left.and.bubble.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(isSelected ? BraisenlyDS.Colors.accentTeal : BraisenlyDS.Colors.textSecondary)
                    .frame(width: 20)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(BraisenlyDS.Typography.rowLabelMedium)
                        .foregroundStyle(isSelected ? BraisenlyDS.Colors.textBright : BraisenlyDS.Colors.textPrimary)
                        .lineLimit(1)
                    if let subtitle, !subtitle.isEmpty {
                        Text(subtitle)
                            .font(BraisenlyDS.Typography.metadata)
                            .foregroundStyle(BraisenlyDS.Colors.textSecondary)
                            .lineLimit(1)
                    }
                }
                Spacer(minLength: 8)
                if let timestampText {
                    Text(timestampText)
                        .font(BraisenlyDS.Typography.metadata)
                        .foregroundStyle(BraisenlyDS.Colors.textSecondary)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .frame(minHeight: resolvedPlatform.rowHeight)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                if isSelected {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(BraisenlyDS.Colors.surfaceHighlight.opacity(0.45))
                }
            }
            .overlay {
                if isSelected {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(BraisenlyDS.Colors.accentTeal.opacity(0.6), lineWidth: 1)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
