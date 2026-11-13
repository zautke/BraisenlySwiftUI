import SwiftUI

/// Native toggle with title and optional subtitle on a content card.
public struct BraisenlyToggleRow: View {
    @Environment(\.braisenlyTheme) private var theme

    public let title: String
    public let subtitle: String?
    @Binding private var isOn: Bool

    public init(_ title: String, subtitle: String? = nil, isOn: Binding<Bool>) {
        self.title = title
        self.subtitle = subtitle
        self._isOn = isOn
    }

    public var body: some View {
        // Same layout on every platform: title (and subtitle) leading, switch trailing, full width.
        HStack(spacing: theme.metrics.spacing[.m]) {
            VStack(alignment: .leading, spacing: theme.metrics.spacing[.xs]) {
                Text(title)
                    .font(theme.typography.rowLabel)
                    .foregroundStyle(theme.colors.textPrimary)
                if let subtitle {
                    Text(subtitle)
                        .font(theme.typography.metadata)
                        .foregroundStyle(theme.colors.textSecondary)
                }
            }
            Spacer(minLength: theme.metrics.spacing[.s])
            Toggle(title, isOn: $isOn)
                .labelsHidden()
                .toggleStyle(.switch)
                .tint(theme.colors.accentTeal)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, theme.metrics.spacing[.m])
        .padding(.vertical, theme.metrics.spacing[.s])
        .braisenlyCard(role: .content)
    }
}
