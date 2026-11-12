import SwiftUI

public struct BraisenlySendStopButton: View {
    @Environment(\.braisenlyTheme) private var theme

    public let isResponding: Bool
    public let canSend: Bool
    public let size: CGFloat
    public let onSend: () -> Void
    public let onCancel: () -> Void

    public init(
        isResponding: Bool,
        canSend: Bool,
        size: CGFloat = 44,
        onSend: @escaping () -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.isResponding = isResponding
        self.canSend = canSend
        self.size = size
        self.onSend = onSend
        self.onCancel = onCancel
    }

    public var body: some View {
        let isEnabled = isResponding || canSend
        Button(action: isResponding ? onCancel : onSend) {
            Image(systemName: isResponding ? "stop.fill" : "arrow.up")
                .font(theme.typography.controlIconEmphasis)
                .foregroundStyle(theme.colors.backgroundPrimary)
                .contentTransition(.symbolEffect(.replace))
                .frame(width: size, height: size)
                .background(
                    Circle().fill(
                        isResponding ? theme.colors.warning : theme.colors.accentTeal
                    )
                )
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.45)
        .accessibilityLabel(isResponding ? "Stop response" : "Send message")
    }
}
