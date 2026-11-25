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

    /// `metadata` is footnote (10 pt on macOS); the caption uses the next larger style so it
    /// never renders below 11 pt.
    static func captionFont(_ theme: BraisenlyThemeDefinition) -> Font { theme.typography.snippetBody }

    public var body: some View {
        VStack(alignment: .leading, spacing: theme.metrics.spacing[.xs]) {
            Text(title)
                .font(Self.captionFont(theme))
                .foregroundStyle(theme.colors.textSecondary)
                .accessibilityHidden(true)
            TextField(title, text: $text, prompt: Text(prompt), axis: axis)
                .font(theme.typography.rowLabel)
                .foregroundStyle(theme.colors.textPrimary)
                .lineLimit(axis == .vertical ? 1...5 : 1...1)
                .textFieldStyle(.plain)
        }
        .padding(.horizontal, theme.metrics.spacing[.m])
        .padding(.vertical, theme.metrics.spacing[.s])
        .frame(maxWidth: .infinity, alignment: .leading)
        .braisenlyCard(cornerRadius: theme.metrics.radius[.m], role: .content)
    }
}
