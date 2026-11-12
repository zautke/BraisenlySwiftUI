import SwiftUI

/// Titled text field on a content card; `.vertical` axis grows up to five lines.
public struct BraisenlyTextFieldRow: View {
    @Environment(\.braisenlyTheme) private var theme

    public let title: String
    @Binding private var text: String
    public let prompt: String
    public let axis: Axis

    public init(_ title: String, text: Binding<String>, prompt: String = "", axis: Axis = .horizontal) {
        self.title = title
        self._text = text
        self.prompt = prompt
        self.axis = axis
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: theme.metrics.spacing[.xs]) {
            Text(title)
                .font(theme.typography.metadata)
                .foregroundStyle(theme.colors.textSecondary)
                .accessibilityHidden(true)
            TextField(title, text: $text, prompt: Text(prompt), axis: axis)
                .font(theme.typography.rowLabel)
                .foregroundStyle(theme.colors.textPrimary)
                .lineLimit(axis == .vertical ? 1...5 : 1...1)
                .textFieldStyle(.plain)
                .accessibilityLabel(title)
        }
        .padding(.horizontal, theme.metrics.spacing[.m])
        .padding(.vertical, theme.metrics.spacing[.s])
        .frame(maxWidth: .infinity, alignment: .leading)
        .braisenlyCard(cornerRadius: theme.metrics.radius[.m], role: .content)
    }
}
