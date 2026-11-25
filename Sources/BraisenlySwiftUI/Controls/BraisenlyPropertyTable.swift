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

    /// `metadata` and `code` are footnote (10 pt on macOS); key and value use the next larger
    /// style (value in its monospaced variant) so neither renders below 11 pt.
    static func keyFont(_ theme: BraisenlyThemeDefinition) -> Font { theme.typography.snippetBody }
    static func valueFont(_ theme: BraisenlyThemeDefinition) -> Font { theme.typography.snippetBody.monospaced() }

    public var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(rows.enumerated()), id: \.offset) { index, row in
                if index > 0 {
                    Rectangle().fill(theme.colors.divider).frame(height: theme.metrics.hairline)
                }
                HStack(alignment: .firstTextBaseline, spacing: theme.metrics.spacing[.m]) {
                    Text(row.key)
                        .font(Self.keyFont(theme))
                        .foregroundStyle(theme.colors.textSecondary)
                    Spacer(minLength: theme.metrics.spacing[.m])
                    Text(row.value)
                        .font(Self.valueFont(theme))
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
