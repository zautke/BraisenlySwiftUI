import SwiftUI

public struct BraisenlyPulseIndicator: View {
    public let label: String

    public init(label: String = "Thinking…") {
        self.label = label
    }

    public var body: some View {
        HStack(spacing: 8) {
            ProgressView()
                .controlSize(.small)
                .tint(BraisenlyDS.Colors.accentTeal)
            Text(label)
                .font(BraisenlyDS.Typography.metadata)
        }
        .foregroundStyle(BraisenlyDS.Colors.textSecondary)
        .accessibilityElement(children: .combine)
    }
}
