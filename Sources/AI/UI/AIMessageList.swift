import BraisenlySwiftUI
import SwiftUI

public struct AIMessageList: View {
    public let messages: [AIMessage]
    public let onSelectSuggestion: (String) -> Void
    public let onRegenerate: () -> Void

    public init(
        messages: [AIMessage],
        onSelectSuggestion: @escaping (String) -> Void,
        onRegenerate: @escaping () -> Void
    ) {
        self.messages = messages
        self.onSelectSuggestion = onSelectSuggestion
        self.onRegenerate = onRegenerate
    }

    public var body: some View {
        if messages.isEmpty {
            AIEmptyState(onSelectSuggestion: onSelectSuggestion)
        } else {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 18) {
                        ForEach(messages) { message in
                            AIMessageBubble(message: message).id(message.id)
                        }
                        if messages.last?.role == .assistant,
                           messages.last?.status == .complete {
                            Button(action: onRegenerate) {
                                Label("Regenerate", systemImage: "arrow.clockwise")
                                    .font(BraisenlyDS.Typography.metadata)
                            }
                            .buttonStyle(.plain)
                            .foregroundStyle(BraisenlyDS.Colors.textSecondary)
                        }
                    }
                    .padding(16)
                    .frame(maxWidth: 860)
                    .frame(maxWidth: .infinity)
                }
                .defaultScrollAnchor(.bottom)
                .onChange(of: messages.count) { _, _ in
                    guard let lastID = messages.last?.id else { return }
                    withAnimation(.snappy) { proxy.scrollTo(lastID, anchor: .bottom) }
                }
            }
        }
    }
}
