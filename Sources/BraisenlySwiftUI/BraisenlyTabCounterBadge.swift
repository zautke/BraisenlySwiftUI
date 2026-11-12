import SwiftUI

public struct BraisenlyTabCounterBadge: View {
    @Environment(\.braisenlyTheme) private var theme

    public let count: Int

    public init(count: Int) {
        self.count = count
    }

    public var body: some View {
        Text(count, format: .number)
            .font(theme.typography.badgeNumber)
            .foregroundStyle(theme.colors.textPrimary)
            .padding(.horizontal, theme.metrics.spacing[.xs])
            .padding(.vertical, theme.metrics.spacing[.xs])
            .overlay(
                RoundedRectangle(cornerRadius: theme.metrics.radius[.xs], style: .continuous)
                    .strokeBorder(theme.colors.textPrimary, lineWidth: theme.metrics.hairline * 3.2)
            )
            .accessibilityLabel("\(count) tabs")
    }
}
