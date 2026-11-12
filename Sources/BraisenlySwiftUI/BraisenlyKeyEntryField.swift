import SwiftUI

public struct BraisenlyKeyEntryField: View {
    @Environment(\.braisenlyTheme) private var theme
    @Binding private var text: String
    @State private var isRevealed = false

    public let title: String
    public let placeholder: String

    public init(
        title: String,
        placeholder: String = "sk-…",
        text: Binding<String>
    ) {
        self.title = title
        self.placeholder = placeholder
        _text = text
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: theme.metrics.spacing[.s]) {
            Text(title)
                .font(theme.typography.metadata)
                .foregroundStyle(theme.colors.textSecondary)
            HStack(spacing: theme.metrics.spacing[.s]) {
                Image(systemName: "key.fill")
                    .foregroundStyle(theme.colors.accentTeal)
                    .frame(width: 20)
                Group {
                    if isRevealed {
                        TextField(placeholder, text: $text)
                    } else {
                        SecureField(placeholder, text: $text)
                    }
                }
                .textFieldStyle(.plain)
                .font(theme.typography.rowLabel)
                .foregroundStyle(theme.colors.textPrimary)
                Button {
                    isRevealed.toggle()
                } label: {
                    Image(systemName: isRevealed ? "eye.slash" : "eye")
                        .foregroundStyle(theme.colors.textSecondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(isRevealed ? "Hide key" : "Show key")
            }
            .padding(.horizontal, theme.metrics.spacing[.m])
            .frame(height: theme.metrics.rowHeight)
            .braisenlyCard(cornerRadius: theme.metrics.radius[.m], fill: theme.colors.surfaceSnippet)
        }
    }
}
