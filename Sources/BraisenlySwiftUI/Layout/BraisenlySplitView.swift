import SwiftUI

/// `NavigationSplitView` that follows the theme: glass themes keep system defaults,
/// solid themes paint sidebar and detail from color tokens.
public struct BraisenlySplitView<Sidebar: View, Detail: View>: View {
    @Environment(\.braisenlyTheme) private var theme
    private let columnVisibility: Binding<NavigationSplitViewVisibility>?
    private let preferredCompactColumn: Binding<NavigationSplitViewColumn>?
    public let extendsDetailBackground: Bool
    private let sidebar: Sidebar
    private let detail: Detail

    public init(columnVisibility: Binding<NavigationSplitViewVisibility>? = nil,
                preferredCompactColumn: Binding<NavigationSplitViewColumn>? = nil,
                extendsDetailBackground: Bool = false,
                @ViewBuilder sidebar: () -> Sidebar,
                @ViewBuilder detail: () -> Detail) {
        self.columnVisibility = columnVisibility
        self.preferredCompactColumn = preferredCompactColumn
        self.extendsDetailBackground = extendsDetailBackground
        self.sidebar = sidebar()
        self.detail = detail()
    }

    public var body: some View {
        NavigationSplitView(
            columnVisibility: columnVisibility ?? .constant(.automatic),
            preferredCompactColumn: preferredCompactColumn ?? .constant(.sidebar)
        ) {
            if theme.surface == .solid {
                sidebar.scrollContentBackground(.hidden).background(theme.colors.backgroundDimmed)
            } else {
                sidebar
            }
        } detail: {
            detailColumn
        }
    }

    @ViewBuilder private var detailColumn: some View {
        if theme.surface == .solid {
            extend(detail.scrollContentBackground(.hidden).background(theme.colors.backgroundPrimary))
        } else {
            extend(detail)
        }
    }

    @ViewBuilder private func extend<V: View>(_ v: V) -> some View {
        if extendsDetailBackground { v.backgroundExtensionEffect() } else { v }
    }
}
