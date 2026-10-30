import BraisenlySwiftUI
import SwiftUI

public struct AIStreamingIndicator: View {
    public init() {}

    public var body: some View {
        HStack(spacing: 8) {
            ProgressView().controlSize(.small)
            Text("Thinking…")
                .font(BraisenlyDS.Typography.metadata)
        }
        .foregroundStyle(BraisenlyDS.Colors.textSecondary)
        .accessibilityElement(children: .combine)
    }
}
