import SwiftUI

/// Card listing key/value pairs, one separated row per entry.
public struct BraisenlyPropertyTable: View {
    @Environment(\.braisenlyTheme) private var theme

    public struct Row: Identifiable, Hashable, Sendable {
        public var key: String
        public var value: String
        public var id: String { key }

        public init(key: String, value: String) {
            self.key = key
            self.value = value
        }
    }

    public let rows: [Row]

    public init(rows: [Row]) {
        self.rows = rows
    }

    public var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(rows.enumerated()), id: \.element.id) { index, row in
                if index > 0 {
                    Rectangle().fill(theme.colors.divider).frame(height: theme.metrics.hairline)
                }
                HStack(alignment: .firstTextBaseline, spacing: theme.metrics.spacing[.m]) {
                    Text(row.key)
                        .font(theme.typography.metadata)
                        .foregroundStyle(theme.colors.textSecondary)
                    Spacer(minLength: theme.metrics.spacing[.m])
                    Text(row.value)
                        .font(theme.typography.code)
                        .foregroundStyle(theme.colors.textPrimary)
                        .multilineTextAlignment(.trailing)
                }
                .padding(.horizontal, theme.metrics.spacing[.l])
                .padding(.vertical, theme.metrics.spacing[.m])
                .accessibilityElement(children: .combine)
            }
        }
        .braisenlyCard(role: .content)
    }
}
