import SwiftUI

/// `NavigationSplitView` that follows the theme: glass themes keep system defaults,
/// solid themes paint sidebar and detail from color tokens. The column modifiers are
/// always applied (values change with the theme), so switching themes keeps column state.
public struct BraisenlySplitView<Sidebar: View, Detail: View>: View {
    @Environment(\.braisenlyTheme) private var theme
    @State private var localVisibility: NavigationSplitViewVisibility = .automatic
    @State private var localCompactColumn: NavigationSplitViewColumn = .sidebar
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
        let solid = theme.surface == .solid
        NavigationSplitView(
            columnVisibility: columnVisibility ?? $localVisibility,
            preferredCompactColumn: preferredCompactColumn ?? $localCompactColumn
        ) {
            sidebar
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .navigationSplitViewColumnWidth(min: 260, ideal: 300, max: 420)
                .scrollContentBackground(solid ? .hidden : .automatic)
                .modifier(SolidMacChrome(solid: solid))
                .background(solid ? theme.colors.backgroundDimmed : Color.clear)
        } detail: {
            extend(detail
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scrollContentBackground(solid ? .hidden : .automatic)
                .modifier(SolidMacChrome(solid: solid))
                .background(solid ? theme.colors.backgroundPrimary : Color.clear))
        }
    }

    @ViewBuilder private func extend<V: View>(_ v: V) -> some View {
        if extendsDetailBackground { v.backgroundExtensionEffect() } else { v }
    }
}

/// macOS solid themes: no toolbar material and no scroll-edge blur, so the window toolbar band
/// shows the column's theme colour. iOS keeps system bars (status bar and nav buttons need the edge effect).
private struct SolidMacChrome: ViewModifier {
    let solid: Bool
    func body(content: Content) -> some View {
        #if os(macOS)
        content
            .scrollEdgeEffectHidden(solid)
            .toolbarBackgroundVisibility(solid ? .hidden : .automatic, for: .windowToolbar)
        #else
        content
        #endif
    }
}
