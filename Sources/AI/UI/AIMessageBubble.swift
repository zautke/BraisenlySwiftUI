import BraisenlySwiftUI
import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public struct AIMessageBubble: View {
    @Environment(\.braisenlyTheme) private var theme
    @State private var isCopied = false

    public let message: AIMessage
    public let canRegenerate: Bool
    public let onRegenerate: (() -> Void)?

    public init(
        message: AIMessage,
        canRegenerate: Bool = false,
        onRegenerate: (() -> Void)? = nil
    ) {
        self.message = message
        self.canRegenerate = canRegenerate
        self.onRegenerate = onRegenerate
    }

    public var body: some View {
        HStack(alignment: .top, spacing: theme.metrics.spacing[.s]) {
            if message.role != .user { avatar }
            VStack(alignment: message.role == .user ? .trailing : .leading, spacing: theme.metrics.spacing[.s]) {
                if !message.text.isEmpty {
                    BraisenlyChatBubbleSurface(
                        text: message.text,
                        fill: message.role == .user
                            ? theme.colors.surfaceHighlight
                            : theme.colors.surfaceElevated
                    )
                }
                ForEach(message.toolCalls) { AIToolCallCard(toolCall: $0) }
                if !message.citations.isEmpty {
                    ScrollView(.horizontal) {
                        HStack(spacing: theme.metrics.spacing[.s]) {
                            ForEach(message.citations) { AICitationChip(citation: $0) }
                        }
                    }
                    .scrollIndicators(.hidden)
                }
                if message.status == .streaming {
                    AIStreamingIndicator()
                } else if message.role == .assistant && !message.text.isEmpty {
                    BraisenlyMessageActionPill(
                        isCopied: isCopied,
                        canRegenerate: canRegenerate,
                        onCopy: copyMessageText,
                        onRegenerate: onRegenerate
                    )
                }
            }
            .frame(maxWidth: 680, alignment: message.role == .user ? .trailing : .leading)
            if message.role == .user { avatar }
        }
        .frame(maxWidth: .infinity, alignment: message.role == .user ? .trailing : .leading)
        .accessibilityElement(children: .contain)
    }

    private var avatar: some View {
        BraisenlyAvatarBadge(
            systemName: message.role == .user ? "person.fill" : "sparkles",
            foregroundColor: message.role == .user
                ? theme.colors.textBright
                : nil
        )
    }

    private func copyMessageText() {
        #if canImport(UIKit)
        UIPasteboard.general.string = message.text
        #elseif canImport(AppKit)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(message.text, forType: .string)
        #endif
        isCopied = true
    }
}
