import BraisenlySwiftUI
import SwiftUI

public struct AIComposer: View {
    @Environment(\.braisenlyTheme) private var theme
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
        let canSend = !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        HStack(alignment: .bottom, spacing: theme.metrics.spacing[.s]) {
            BraisenlyPromptField(
                "Message Askenly…",
                text: $text,
                onSubmit: {
                    if canSend { onSend() }
                }
            )

            BraisenlySendStopButton(
                isResponding: isResponding,
                canSend: canSend,
                onSend: onSend,
                onCancel: onCancel
            )
        }
    }
}
