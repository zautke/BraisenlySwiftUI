import BraisenlySwiftUI
import SwiftUI

public struct AIComposer: View {
    @Binding private var text: String

    public let isResponding: Bool
    public let onSend: () -> Void
    public let onCancel: () -> Void

    public init(
        text: Binding<String>,
        isResponding: Bool,
        onSend: @escaping () -> Void,
        onCancel: @escaping () -> Void
    ) {
        _text = text
        self.isResponding = isResponding
        self.onSend = onSend
        self.onCancel = onCancel
    }

    public var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            TextField("Message Braisenly…", text: $text, axis: .vertical)
                .textFieldStyle(.plain)
                .font(BraisenlyDS.Typography.rowLabel)
                .foregroundStyle(BraisenlyDS.Colors.textPrimary)
                .lineLimit(1...6)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .braisenlyCard(cornerRadius: 18, fill: BraisenlyDS.Colors.surfaceElevated)
                .onSubmit {
                    if !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { onSend() }
                }

            Button(action: isResponding ? onCancel : onSend) {
                Image(systemName: isResponding ? "stop.fill" : "arrow.up")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(BraisenlyDS.Colors.backgroundPrimary)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(BraisenlyDS.Colors.accentTeal))
            }
            .buttonStyle(.plain)
            .disabled(!isResponding && text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .opacity(!isResponding && text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.45 : 1)
            .accessibilityLabel(isResponding ? "Stop response" : "Send message")
        }
    }
}
