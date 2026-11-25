import SwiftUI

public struct BraisenlyRegularWorkspace: View {
    public let documentTitle: String
    public let documentText: String
    public let platform: BraisenlyPlatform
    @Binding private var isActionSheetPresented: Bool
    @Binding private var isContextPopoverOpen: Bool
    @Binding private var searchText: String
    @Binding private var selectedMode: BraisenlySidebarMode
    @Binding private var themeID: BraisenlyThemeDefinition.ID
    @State private var columnVisibility = NavigationSplitViewVisibility.all

    public init(
        documentTitle: String,
        documentText: String,
        platform: BraisenlyPlatform,
        isActionSheetPresented: Binding<Bool>,
        isContextPopoverOpen: Binding<Bool>,
        searchText: Binding<String>,
        selectedMode: Binding<BraisenlySidebarMode>,
        theme: Binding<BraisenlyThemeDefinition.ID>
    ) {
        self.documentTitle = documentTitle
        self.documentText = documentText
        self.platform = platform
        _isActionSheetPresented = isActionSheetPresented
        _isContextPopoverOpen = isContextPopoverOpen
        _searchText = searchText
        _selectedMode = selectedMode
        _themeID = theme
    }

    public var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            BraisenlySidebarDrawer(
                searchText: $searchText,
                selectedMode: $selectedMode,
                isShowingContextPopover: $isContextPopoverOpen,
                platform: platform
            )
            .navigationSplitViewColumnWidth(
                min: platform == .mac ? 260 : 300,
                ideal: platform == .mac ? 320 : 360,
                max: platform == .mac ? 420 : 460
            )
            // The document chrome owns the sidebar toggle (`toggleSidebar()`); drop the system one on iOS,
            // where it floats in the column's own bar. On macOS the removal reaches the window toolbar
            // and would also strip the host window's toggle.
            #if os(iOS)
            .toolbar(removing: .sidebarToggle)
            #endif
        } detail: {
            BraisenlyDocumentCanvas(
                title: documentTitle,
                bodyText: documentText,
                theme: $themeID,
                platform: platform,
                onToggleSidebar: toggleSidebar,
                onOpenActionSheet: { isActionSheetPresented = true }
            )
        }
        .navigationSplitViewStyle(.balanced)
    }

    private func toggleSidebar() {
        withAnimation {
            columnVisibility = columnVisibility == .all ? .detailOnly : .all
        }
    }
}
