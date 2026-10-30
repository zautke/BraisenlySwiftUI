import SwiftUI

public struct BraisenlyActionItem: Identifiable, Sendable, Equatable {
    public let id: String
    public let icon: String
    public let title: LocalizedStringResource
    public var isChecked: Bool

    public init(
        id: String,
        icon: String,
        title: LocalizedStringResource,
        isChecked: Bool = false
    ) {
        self.id = id
        self.icon = icon
        self.title = title
        self.isChecked = isChecked
    }
}

public struct BraisenlyActionRow: View {
    public let item: BraisenlyActionItem

    public init(item: BraisenlyActionItem) {
        self.item = item
    }

    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: item.icon).frame(width: 22)
            Text(item.title)
            Spacer()
            if item.isChecked { Image(systemName: "checkmark").fontWeight(.semibold) }
        }
        .font(BraisenlyDS.Typography.rowLabel)
        .foregroundStyle(BraisenlyDS.Colors.textPrimary)
        .padding(.horizontal, 16)
        .frame(minHeight: BraisenlyDS.Metrics.rowHeight)
        .contentShape(Rectangle())
    }
}

public struct BraisenlyActionGroup: View {
    public let items: [BraisenlyActionItem]
    public let action: (BraisenlyActionItem) -> Void

    public init(items: [BraisenlyActionItem], action: @escaping (BraisenlyActionItem) -> Void) {
        self.items = items
        self.action = action
    }

    public var body: some View {
        VStack(spacing: 0) {
            ForEach(items) { item in
                Button { action(item) } label: { BraisenlyActionRow(item: item) }
                    .buttonStyle(.plain)
                if item.id != items.last?.id {
                    Divider().overlay(BraisenlyDS.Colors.divider).padding(.horizontal, 16)
                }
            }
        }
        .braisenlyCard()
    }
}

public struct BraisenlyDocumentActionSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var toggles = [
        BraisenlyActionItem(id: "backlinks", icon: "link", title: "Backlinks in document", isChecked: true),
        BraisenlyActionItem(id: "reading", icon: "book", title: "Reading view", isChecked: true)
    ]
    private let fileActions = [
        BraisenlyActionItem(id: "unpin", icon: "pin.slash", title: "Unpin"),
        BraisenlyActionItem(id: "rename", icon: "pencil.line", title: "Rename…"),
        BraisenlyActionItem(id: "move", icon: "folder", title: "Move file to…"),
        BraisenlyActionItem(id: "bookmark", icon: "bookmark", title: "Bookmark…"),
        BraisenlyActionItem(id: "merge", icon: "arrow.triangle.merge", title: "Merge entire file with…"),
        BraisenlyActionItem(id: "publish", icon: "paperplane", title: "Publish current file"),
        BraisenlyActionItem(id: "property", icon: "plus.circle", title: "Add file property")
    ]

    public init() {}

    public var body: some View {
        ZStack {
            BraisenlyDS.Colors.surfaceSheet.ignoresSafeArea()
            VStack(spacing: 14) {
                Capsule().fill(BraisenlyDS.Colors.textSecondary.opacity(0.6)).frame(width: 46, height: 5)
                ScrollView {
                    VStack(spacing: 16) {
                        Button { dismiss() } label: {
                            BraisenlyActionRow(item: .init(id: "close", icon: "xmark", title: "Close"))
                                .braisenlyCard(cornerRadius: 24)
                        }
                        .buttonStyle(.plain)
                        BraisenlyActionGroup(items: toggles, action: toggle)
                        BraisenlyActionGroup(items: fileActions) { _ in }
                        BraisenlyActionGroup(
                            items: [.init(id: "find", icon: "doc.text.magnifyingglass", title: "Find…")]
                        ) { _ in }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
            }
            .padding(.top, 10)
        }
    }

    private func toggle(_ item: BraisenlyActionItem) {
        guard let index = toggles.firstIndex(where: { $0.id == item.id }) else { return }
        toggles[index].isChecked.toggle()
    }
}
