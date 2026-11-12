import BraisenlySwiftUI
import SwiftUI

public struct AIToolCallCard: View {
    @Environment(\.braisenlyTheme) private var theme
    public let toolCall: AIToolCall

    public init(toolCall: AIToolCall) {
        self.toolCall = toolCall
    }

    public var body: some View {
        BraisenlyStatusCard(
            title: toolCall.name,
            subtitle: toolCall.summary,
            systemImage: iconName,
            iconColor: iconColor
        )
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
        case .pending, .running: theme.colors.accentTeal
        case .complete: theme.colors.success
        case .failed: theme.colors.danger
        }
    }
}
