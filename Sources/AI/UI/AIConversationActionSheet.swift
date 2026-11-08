import BraisenlySwiftUI
import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public struct AIConversationActionSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var draftTitle: String

    public let isPinned: Bool
    public let platform: BraisenlyPlatform
    public let onRename: (String) -> Void
    public let onTogglePin: () -> Void
    public let onExportMarkdown: () -> String
    public let onClearMessages: () -> Void
    public let onDeleteConversation: () -> Void

    public init(
        conversationTitle: String,
        isPinned: Bool,
        platform: BraisenlyPlatform = .automatic,
        onRename: @escaping (String) -> Void,
        onTogglePin: @escaping () -> Void,
        onExportMarkdown: @escaping () -> String,
        onClearMessages: @escaping () -> Void,
        onDeleteConversation: @escaping () -> Void
    ) {
        _draftTitle = State(initialValue: conversationTitle)
        self.isPinned = isPinned
        self.platform = platform
        self.onRename = onRename
        self.onTogglePin = onTogglePin
        self.onExportMarkdown = onExportMarkdown
        self.onClearMessages = onClearMessages
        self.onDeleteConversation = onDeleteConversation
    }

    public var body: some View {
        let resolvedPlatform = platform.resolved(horizontalSizeClass: horizontalSizeClass)
        let actionItems = [
            BraisenlyActionItem(
                id: "pin",
                icon: isPinned ? "pin.slash" : "pin",
                title: isPinned ? "Unpin conversation" : "Pin conversation",
                isChecked: isPinned
            ),
            BraisenlyActionItem(
                id: "copy-markdown",
                icon: "doc.on.clipboard",
                title: "Copy thread as Markdown"
            ),
            BraisenlyActionItem(
                id: "clear",
                icon: "eraser",
                title: "Clear messages in thread"
            ),
            BraisenlyActionItem(
                id: "delete",
                icon: "trash",
                title: "Delete conversation"
            )
        ]

        ZStack {
            BraisenlyDS.Colors.surfaceSheet.ignoresSafeArea()
            VStack(spacing: 14) {
                if resolvedPlatform != .mac {
                    Capsule()
                        .fill(BraisenlyDS.Colors.textSecondary.opacity(0.6))
                        .frame(width: 46, height: 5)
                }

                ScrollView {
                    VStack(spacing: resolvedPlatform == .mac ? 12 : 16) {
                        Button { dismiss() } label: {
                            BraisenlyActionRow(
                                item: .init(id: "close", icon: "xmark", title: "Close"),
                                platform: resolvedPlatform
                            )
                            .braisenlyCard(cornerRadius: 24)
                        }
                        .buttonStyle(.plain)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Conversation Title")
                                .font(BraisenlyDS.Typography.metadata)
                                .foregroundStyle(BraisenlyDS.Colors.textSecondary)
                            HStack(spacing: 10) {
                                BraisenlyPromptField("Conversation title…", text: $draftTitle) {
                                    onRename(draftTitle)
                                }
                                BraisenlyCircleIconButton(
                                    systemName: "checkmark",
                                    accessibilityLabel: "Save title",
                                    platform: resolvedPlatform
                                ) {
                                    onRename(draftTitle)
                                    dismiss()
                                }
                            }
                        }

                        BraisenlyActionGroup(items: actionItems, platform: resolvedPlatform) { item in
                            switch item.id {
                            case "pin":
                                onTogglePin()
                                dismiss()
                            case "copy-markdown":
                                let markdown = onExportMarkdown()
                                #if canImport(UIKit)
                                UIPasteboard.general.string = markdown
                                #elseif canImport(AppKit)
                                NSPasteboard.general.clearContents()
                                NSPasteboard.general.setString(markdown, forType: .string)
                                #endif
                                dismiss()
                            case "clear":
                                onClearMessages()
                                dismiss()
                            case "delete":
                                onDeleteConversation()
                                dismiss()
                            default:
                                break
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                    .frame(maxWidth: resolvedPlatform == .mac ? 480 : 620)
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, resolvedPlatform == .mac ? 16 : 10)
        }
        .frame(minWidth: resolvedPlatform == .mac ? 440 : nil, minHeight: resolvedPlatform == .mac ? 520 : nil)
    }
}
