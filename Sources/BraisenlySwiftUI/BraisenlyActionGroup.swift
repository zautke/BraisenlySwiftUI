import SwiftUI

public struct BraisenlyActionGroup: View {
    @Environment(\.braisenlyTheme) private var theme

    public let items: [BraisenlyActionItem]
    public let platform: BraisenlyPlatform
    public let action: (BraisenlyActionItem) -> Void

    public init(
        items: [BraisenlyActionItem],
        platform: BraisenlyPlatform = .automatic,
        action: @escaping (BraisenlyActionItem) -> Void
    ) {
        self.items = items
        self.platform = platform
        self.action = action
    }

    public var body: some View {
        VStack(spacing: 0) {
            ForEach(items) { item in
                Button { action(item) } label: { BraisenlyActionRow(item: item, platform: platform) }
                    .buttonStyle(.plain)
                if item.id != items.last?.id {
                    Divider().overlay(theme.colors.divider).padding(.horizontal, theme.metrics.spacing[.l])
                }
            }
        }
        .braisenlyCard()
    }
}
