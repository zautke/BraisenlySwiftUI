import SwiftUI

public struct BraisenlyBottomToolbar: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    public let tabCount: Int
    public let platform: BraisenlyPlatform
    public let onBack: () -> Void
    public let onForward: () -> Void
    public let onSearch: () -> Void
    public let onAdd: () -> Void
    public let onTabs: () -> Void
    public let onMenu: () -> Void

    public init(
        tabCount: Int = 23,
        platform: BraisenlyPlatform = .automatic,
        onBack: @escaping () -> Void = {},
        onForward: @escaping () -> Void = {},
        onSearch: @escaping () -> Void = {},
        onAdd: @escaping () -> Void = {},
        onTabs: @escaping () -> Void = {},
        onMenu: @escaping () -> Void = {}
    ) {
        self.tabCount = tabCount
        self.platform = platform
        self.onBack = onBack
        self.onForward = onForward
        self.onSearch = onSearch
        self.onAdd = onAdd
        self.onTabs = onTabs
        self.onMenu = onMenu
    }

    public var body: some View {
        let resolvedPlatform = platform.resolved(horizontalSizeClass: horizontalSizeClass)
        HStack(spacing: resolvedPlatform == .iPad ? 36 : 28) {
            BraisenlyToolbarIconButton(systemName: "chevron.left", label: "Back", action: onBack)
            BraisenlyToolbarIconButton(systemName: "chevron.right", label: "Forward", isEnabled: false, action: onForward)
            BraisenlyToolbarIconButton(systemName: "magnifyingglass", label: "Search", action: onSearch)
            BraisenlyToolbarIconButton(systemName: "plus", label: "Add", action: onAdd)
            Button(action: onTabs) { BraisenlyTabCounterBadge(count: tabCount) }
                .accessibilityLabel("Tabs")
            BraisenlyToolbarIconButton(systemName: "line.3.horizontal", label: "Menu", action: onMenu)
        }
        .buttonStyle(.plain)
        .padding(.horizontal, resolvedPlatform == .mac ? 18 : 26)
        .frame(height: resolvedPlatform == .mac ? 44 : BraisenlyDS.Metrics.toolbarHeight)
        .braisenlyCapsule()
    }
}
