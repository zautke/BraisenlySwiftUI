import SwiftUI

/// Centered placeholder: icon, title, optional message and optional action button.
public struct BraisenlyEmptyState: View {
    @Environment(\.braisenlyTheme) private var theme

    public let title: String
    public let message: String?
    public let systemImage: String
    public let actionTitle: String?
    private let action: (() -> Void)?

    public init(
        title: String,
        message: String? = nil,
        systemImage: String = "square.dashed",
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.systemImage = systemImage
        self.actionTitle = actionTitle
        self.action = action
    }

    /// True only when both the action title and the action closure are set.
    public var hasAction: Bool { actionTitle != nil && action != nil }

    public var body: some View {
        VStack(spacing: theme.metrics.spacing[.m]) {
            Image(systemName: systemImage)
                .font(theme.typography.documentTitle)
                .foregroundStyle(theme.colors.textSecondary)
            Text(title)
                .font(theme.typography.vaultTitle)
                .foregroundStyle(theme.colors.textBright)
            if let message {
                Text(message)
                    .font(theme.typography.snippetBody)
                    .foregroundStyle(theme.colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            if let actionTitle, let action {
                BraisenlyButton(actionTitle, prominence: .prominent, action: action)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(theme.metrics.spacing[.xl])
        .accessibilityElement(children: .combine)
    }
}
