import SwiftUI

public struct BraisenlyKeyEntryField: View {
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
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(BraisenlyDS.Typography.metadata)
                .foregroundStyle(BraisenlyDS.Colors.textSecondary)
            HStack(spacing: 10) {
                Image(systemName: "key.fill")
                    .foregroundStyle(BraisenlyDS.Colors.accentTeal)
                    .frame(width: 20)
                Group {
                    if isRevealed {
                        TextField(placeholder, text: $text)
                    } else {
                        SecureField(placeholder, text: $text)
                    }
                }
                .textFieldStyle(.plain)
                .font(BraisenlyDS.Typography.rowLabel)
                .foregroundStyle(BraisenlyDS.Colors.textPrimary)
                Button {
                    isRevealed.toggle()
                } label: {
                    Image(systemName: isRevealed ? "eye.slash" : "eye")
                        .foregroundStyle(BraisenlyDS.Colors.textSecondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(isRevealed ? "Hide key" : "Show key")
            }
            .padding(.horizontal, 14)
            .frame(height: BraisenlyDS.Metrics.rowHeight)
            .braisenlyCard(cornerRadius: 14, fill: BraisenlyDS.Colors.surfaceSnippet)
        }
    }
}
