import SwiftUI

public struct BraisenlyCompactWorkspace: View {
    @Environment(\.braisenlyTheme) private var theme
    public let documentTitle: String
    public let documentText: String
    @Binding private var isSidebarOpen: Bool
    @Binding private var isActionSheetPresented: Bool
    @Binding private var isContextPopoverOpen: Bool
    @Binding private var searchText: String
    @Binding private var selectedMode: BraisenlySidebarMode
    @Binding private var themeID: BraisenlyThemeDefinition.ID

    public init(
        documentTitle: String,
        documentText: String,
        isSidebarOpen: Binding<Bool>,
        isActionSheetPresented: Binding<Bool>,
        isContextPopoverOpen: Binding<Bool>,
        searchText: Binding<String>,
        selectedMode: Binding<BraisenlySidebarMode>,
        theme: Binding<BraisenlyThemeDefinition.ID>
    ) {
        self.documentTitle = documentTitle
        self.documentText = documentText
        _isSidebarOpen = isSidebarOpen
        _isActionSheetPresented = isActionSheetPresented
        _isContextPopoverOpen = isContextPopoverOpen
        _searchText = searchText
        _selectedMode = selectedMode
        _themeID = theme
    }

    public var body: some View {
        GeometryReader { proxy in
            let sidebarWidth = proxy.size.width * theme.metrics.sidebarWidthRatio
            ZStack(alignment: .leading) {
                BraisenlyDocumentCanvas(
                    title: documentTitle,
                    bodyText: documentText,
                    theme: $themeID,
                    platform: .iPhone,
                    onToggleSidebar: toggleSidebar,
                    onOpenActionSheet: { isActionSheetPresented = true }
                )
                .offset(x: isSidebarOpen ? sidebarWidth : 0)
                .overlay {
                    if isSidebarOpen {
                        theme.colors.scrim.ignoresSafeArea().onTapGesture(perform: closeSidebar)
                    }
                }
                if isSidebarOpen {
                    BraisenlySidebarDrawer(
                        searchText: $searchText,
                        selectedMode: $selectedMode,
                        isShowingContextPopover: $isContextPopoverOpen,
                        platform: .iPhone
                    )
                    .frame(width: sidebarWidth)
                    .transition(.move(edge: .leading))
                }
            }
        }
    }

    private func toggleSidebar() {
        withAnimation(.spring(response: 0.32, dampingFraction: 0.86)) { isSidebarOpen.toggle() }
    }

    private func closeSidebar() {
        withAnimation(.spring(response: 0.32, dampingFraction: 0.86)) {
            isSidebarOpen = false
            isContextPopoverOpen = false
        }
    }
}
