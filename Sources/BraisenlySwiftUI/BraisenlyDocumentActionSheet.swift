import SwiftUI

public struct BraisenlyDocumentActionSheet: View {
    @Environment(\.braisenlyTheme) private var theme
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var toggles = [
        BraisenlyActionItem(id: "backlinks", icon: "link", title: "Backlinks in document", isChecked: true),
        BraisenlyActionItem(id: "reading", icon: "book", title: "Reading view", isChecked: true)
    ]

    public let platform: BraisenlyPlatform
    private let fileActions = [
        BraisenlyActionItem(id: "unpin", icon: "pin.slash", title: "Unpin"),
        BraisenlyActionItem(id: "rename", icon: "pencil.line", title: "Rename…"),
        BraisenlyActionItem(id: "move", icon: "folder", title: "Move file to…"),
        BraisenlyActionItem(id: "bookmark", icon: "bookmark", title: "Bookmark…"),
        BraisenlyActionItem(id: "merge", icon: "arrow.triangle.merge", title: "Merge entire file with…"),
        BraisenlyActionItem(id: "publish", icon: "paperplane", title: "Publish current file"),
        BraisenlyActionItem(id: "property", icon: "plus.circle", title: "Add file property")
    ]

    public init(platform: BraisenlyPlatform = .automatic) {
        self.platform = platform
    }

    public var body: some View {
        let resolvedPlatform = platform.resolved(horizontalSizeClass: horizontalSizeClass)
        ZStack {
            if theme.surface == .solid { theme.colors.surfaceSheet.ignoresSafeArea() }
            VStack(spacing: theme.metrics.spacing[.m]) {
                if resolvedPlatform != .mac {
                    Capsule().fill(theme.colors.textSecondary.opacity(0.6))
                        .frame(width: theme.metrics.grabberSize.width, height: theme.metrics.grabberSize.height)
                }
                ScrollView {
                    VStack(spacing: resolvedPlatform == .mac ? theme.metrics.spacing[.m] : theme.metrics.spacing[.l]) {
                        Button { dismiss() } label: {
                            BraisenlyActionRow(
                                item: .init(id: "close", icon: "xmark", title: "Close"),
                                platform: resolvedPlatform
                            )
                            .braisenlyCard(cornerRadius: theme.metrics.radius[.xl])
                        }
                        .buttonStyle(.plain)
                        BraisenlyActionGroup(items: toggles, platform: resolvedPlatform, action: toggle)
                        BraisenlyActionGroup(items: fileActions, platform: resolvedPlatform) { _ in }
                        BraisenlyActionGroup(
                            items: [.init(id: "find", icon: "doc.text.magnifyingglass", title: "Find…")],
                            platform: resolvedPlatform
                        ) { _ in }
                    }
                    .padding(.horizontal, theme.metrics.spacing[.l])
                    .padding(.bottom, theme.metrics.spacing[.xl])
                    .frame(maxWidth: resolvedPlatform == .mac ? 480 : 620)
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, resolvedPlatform == .mac ? theme.metrics.spacing[.l] : theme.metrics.spacing[.s])
        }
        .frame(minWidth: resolvedPlatform == .mac ? 440 : nil, minHeight: resolvedPlatform == .mac ? 620 : nil)
    }

    private func toggle(_ item: BraisenlyActionItem) {
        guard let index = toggles.firstIndex(where: { $0.id == item.id }) else { return }
        toggles[index].isChecked.toggle()
    }
}
