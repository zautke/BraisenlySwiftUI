import SwiftUI

public struct BraisenlyModelPill: View {
    @Environment(\.braisenlyTheme) private var theme

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
        HStack(spacing: theme.metrics.spacing[.s]) {
            Image(systemName: systemImage)
                .font(theme.typography.chipLabel)
                .foregroundStyle(theme.colors.accentTeal)
            Text(title)
                .font(theme.typography.metadata)
                .foregroundStyle(theme.colors.textPrimary)
                .lineLimit(1)
            if isInteractive {
                Image(systemName: "chevron.down")
                    .font(theme.typography.chipLabel)
                    .foregroundStyle(theme.colors.textSecondary)
            }
        }
        .padding(.horizontal, theme.metrics.spacing[.s])
        .padding(.vertical, theme.metrics.spacing[.xs])
        .braisenlyCapsule(fill: theme.colors.surfaceSnippet, role: isInteractive ? .control : .chrome)
    }
}
