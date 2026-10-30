import BraisenlySwiftUI
import SwiftUI

public struct AIMessageBubble: View {
    public let message: AIMessage

    public init(message: AIMessage) {
        self.message = message
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if message.role != .user { avatar }
            VStack(alignment: message.role == .user ? .trailing : .leading, spacing: 10) {
                if !message.text.isEmpty {
                    Text(message.text)
                        .font(BraisenlyDS.Typography.bodyReading)
                        .foregroundStyle(BraisenlyDS.Colors.textPrimary)
                        .textSelection(.enabled)
                        .padding(14)
                        .braisenlyCard(
                            cornerRadius: 18,
                            fill: message.role == .user
                                ? BraisenlyDS.Colors.surfaceHighlight
                                : BraisenlyDS.Colors.surfaceElevated
                        )
                }
                ForEach(message.toolCalls) { AIToolCallCard(toolCall: $0) }
                if !message.citations.isEmpty {
                    ScrollView(.horizontal) {
                        HStack(spacing: 8) {
                            ForEach(message.citations) { AICitationChip(citation: $0) }
                        }
                    }
                    .scrollIndicators(.hidden)
                }
                if message.status == .streaming { AIStreamingIndicator() }
            }
            .frame(maxWidth: 680, alignment: message.role == .user ? .trailing : .leading)
            if message.role == .user { avatar }
        }
        .frame(maxWidth: .infinity, alignment: message.role == .user ? .trailing : .leading)
        .accessibilityElement(children: .contain)
    }

    private var avatar: some View {
        Image(systemName: message.role == .user ? "person.fill" : "sparkles")
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(message.role == .user ? BraisenlyDS.Colors.textBright : BraisenlyDS.Colors.accentTeal)
            .frame(width: 32, height: 32)
            .background(Circle().fill(BraisenlyDS.Colors.surfaceElevated))
            .overlay(Circle().strokeBorder(BraisenlyDS.Colors.borderSubtle))
            .accessibilityHidden(true)
    }
}
