import BraisenlySwiftUI
import SwiftUI

public struct AIChatErrorBanner: View {
    public let failure: AIChatFailure
    public let onDismiss: () -> Void

    public init(failure: AIChatFailure, onDismiss: @escaping () -> Void) {
        self.failure = failure
        self.onDismiss = onDismiss
    }

    public var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(BraisenlyDS.Solarized.red)
            Text(failure.message)
                .font(BraisenlyDS.Typography.metadata)
                .foregroundStyle(BraisenlyDS.Colors.textPrimary)
            Spacer()
            Button(action: onDismiss) { Image(systemName: "xmark") }
                .buttonStyle(.plain)
                .accessibilityLabel("Dismiss error")
        }
        .padding(12)
        .braisenlyCard(cornerRadius: 12, fill: BraisenlyDS.Colors.surfaceSnippet)
    }
}
