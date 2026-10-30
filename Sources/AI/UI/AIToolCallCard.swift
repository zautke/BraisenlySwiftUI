import BraisenlySwiftUI
import SwiftUI

public struct AIToolCallCard: View {
    public let toolCall: AIToolCall

    public init(toolCall: AIToolCall) {
        self.toolCall = toolCall
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: iconName)
                .foregroundStyle(iconColor)
                .frame(width: 20)
            VStack(alignment: .leading, spacing: 3) {
                Text(toolCall.name).font(BraisenlyDS.Typography.rowLabelMedium)
                if !toolCall.summary.isEmpty {
                    Text(toolCall.summary)
                        .font(BraisenlyDS.Typography.metadata)
                        .foregroundStyle(BraisenlyDS.Colors.textSecondary)
                }
            }
            Spacer(minLength: 0)
        }
        .foregroundStyle(BraisenlyDS.Colors.textPrimary)
        .padding(12)
        .braisenlyCard(cornerRadius: BraisenlyDS.Metrics.snippetRadius, fill: BraisenlyDS.Colors.surfaceSnippet)
        .accessibilityElement(children: .combine)
    }

    private var iconName: String {
        switch toolCall.state {
        case .pending: "clock"
        case .running: "gearshape.2"
        case .complete: "checkmark.circle.fill"
        case .failed: "exclamationmark.triangle.fill"
        }
    }

    private var iconColor: Color {
        switch toolCall.state {
        case .pending, .running: BraisenlyDS.Colors.accentTeal
        case .complete: BraisenlyDS.Solarized.green
        case .failed: BraisenlyDS.Solarized.red
        }
    }
}
