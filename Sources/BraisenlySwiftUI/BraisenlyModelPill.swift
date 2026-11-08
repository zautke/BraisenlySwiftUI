import SwiftUI

public struct BraisenlyModelPill: View {
    public let title: String
    public let systemImage: String
    public let isInteractive: Bool
    public let action: (() -> Void)?

    public init(
        title: String,
        systemImage: String = "cpu",
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.systemImage = systemImage
        self.isInteractive = action != nil
        self.action = action
    }

    public var body: some View {
        if let action {
            Button(action: action) { label }
                .buttonStyle(.plain)
        } else {
            label
        }
    }

    private var label: some View {
        HStack(spacing: 6) {
            Image(systemName: systemImage)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(BraisenlyDS.Colors.accentTeal)
            Text(title)
                .font(BraisenlyDS.Typography.metadata)
                .foregroundStyle(BraisenlyDS.Colors.textPrimary)
                .lineLimit(1)
            if isInteractive {
                Image(systemName: "chevron.down")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(BraisenlyDS.Colors.textSecondary)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .braisenlyCapsule(fill: BraisenlyDS.Colors.surfaceSnippet)
    }
}
