import SwiftUI

/// Uppercase section caption with optional leading icon and trailing text.
public struct BraisenlySectionHeader: View {
    @Environment(\.braisenlyTheme) private var theme

    public let title: String
    public let systemImage: String?
    public let trailing: String?

    public init(_ title: String, systemImage: String? = nil, trailing: String? = nil) {
        self.title = title
        self.systemImage = systemImage
        self.trailing = trailing
    }

    public var body: some View {
        HStack(spacing: theme.metrics.spacing[.xs]) {
            if let systemImage {
                Image(systemName: systemImage).accessibilityHidden(true)
            }
            Text(title.uppercased())
            Spacer(minLength: theme.metrics.spacing[.s])
            if let trailing { Text(trailing) }
        }
        .font(theme.typography.metadata)
        .foregroundStyle(theme.colors.textSecondary)
        .padding(.horizontal, theme.metrics.spacing[.l])
        .padding(.top, theme.metrics.spacing[.l])
        .padding(.bottom, theme.metrics.spacing[.xs])
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isHeader)
    }
}
