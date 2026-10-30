import SwiftUI

public struct BraisenlyActionRow: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    public let item: BraisenlyActionItem
    public let platform: BraisenlyPlatform

    public init(item: BraisenlyActionItem, platform: BraisenlyPlatform = .automatic) {
        self.item = item
        self.platform = platform
    }

    public var body: some View {
        let resolvedPlatform = platform.resolved(horizontalSizeClass: horizontalSizeClass)
        HStack(spacing: 12) {
            Image(systemName: item.icon).frame(width: 22)
            Text(item.title)
            Spacer()
            if item.isChecked { Image(systemName: "checkmark").fontWeight(.semibold) }
        }
        .font(BraisenlyDS.Typography.rowLabel)
        .foregroundStyle(BraisenlyDS.Colors.textPrimary)
        .padding(.horizontal, 16)
        .frame(minHeight: resolvedPlatform.rowHeight)
        .contentShape(Rectangle())
    }
}
