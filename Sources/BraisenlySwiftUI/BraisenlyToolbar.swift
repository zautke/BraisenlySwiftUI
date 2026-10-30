import SwiftUI

public struct BraisenlyBottomToolbar: View {
    public let tabCount: Int
    public let onBack: () -> Void
    public let onForward: () -> Void
    public let onSearch: () -> Void
    public let onAdd: () -> Void
    public let onTabs: () -> Void
    public let onMenu: () -> Void

    public init(
        tabCount: Int = 23,
        onBack: @escaping () -> Void = {},
        onForward: @escaping () -> Void = {},
        onSearch: @escaping () -> Void = {},
        onAdd: @escaping () -> Void = {},
        onTabs: @escaping () -> Void = {},
        onMenu: @escaping () -> Void = {}
    ) {
        self.tabCount = tabCount
        self.onBack = onBack
        self.onForward = onForward
        self.onSearch = onSearch
        self.onAdd = onAdd
        self.onTabs = onTabs
        self.onMenu = onMenu
    }

    public var body: some View {
        HStack(spacing: 28) {
            ToolbarIconButton(systemName: "chevron.left", label: "Back", action: onBack)
            ToolbarIconButton(systemName: "chevron.right", label: "Forward", isEnabled: false, action: onForward)
            ToolbarIconButton(systemName: "magnifyingglass", label: "Search", action: onSearch)
            ToolbarIconButton(systemName: "plus", label: "Add", action: onAdd)
            Button(action: onTabs) { BraisenlyTabCounterBadge(count: tabCount) }
                .accessibilityLabel("Tabs")
            ToolbarIconButton(systemName: "line.3.horizontal", label: "Menu", action: onMenu)
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 26)
        .frame(height: BraisenlyDS.Metrics.toolbarHeight)
        .braisenlyCapsule()
    }
}

private struct ToolbarIconButton: View {
    let systemName: String
    let label: LocalizedStringResource
    var isEnabled = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(isEnabled ? BraisenlyDS.Colors.textPrimary : BraisenlyDS.Colors.textDisabled)
        }
        .disabled(!isEnabled)
        .accessibilityLabel(Text(label))
    }
}
