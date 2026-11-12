import SwiftUI

public struct BraisenlyPulseIndicator: View {
    @Environment(\.braisenlyTheme) private var theme

    public let label: String

    public init(label: String = "Thinking…") {
        self.label = label
    }

    public var body: some View {
        HStack(spacing: theme.metrics.spacing[.s]) {
            ProgressView()
                .controlSize(.small)
                .tint(theme.colors.accentTeal)
            Text(label)
                .font(theme.typography.metadata)
        }
        .foregroundStyle(theme.colors.textSecondary)
        .accessibilityElement(children: .combine)
    }
}
