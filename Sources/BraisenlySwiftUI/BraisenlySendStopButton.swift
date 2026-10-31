import SwiftUI

public struct BraisenlySendStopButton: View {
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
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(BraisenlyDS.Colors.backgroundPrimary)
                .contentTransition(.symbolEffect(.replace))
                .frame(width: size, height: size)
                .background(
                    Circle().fill(
                        isResponding ? BraisenlyDS.Solarized.orange : BraisenlyDS.Colors.accentTeal
                    )
                )
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.45)
        .accessibilityLabel(isResponding ? "Stop response" : "Send message")
    }
}
