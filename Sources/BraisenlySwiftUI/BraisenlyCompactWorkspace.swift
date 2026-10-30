import SwiftUI

public struct BraisenlyCompactWorkspace: View {
    public let documentTitle: String
    public let documentText: String
    @Binding private var isSidebarOpen: Bool
    @Binding private var isActionSheetPresented: Bool
    @Binding private var isContextPopoverOpen: Bool
    @Binding private var searchText: String
    @Binding private var selectedMode: BraisenlySidebarMode
    @Binding private var theme: BraisenlyTheme

    public init(
        documentTitle: String,
        documentText: String,
        isSidebarOpen: Binding<Bool>,
        isActionSheetPresented: Binding<Bool>,
        isContextPopoverOpen: Binding<Bool>,
        searchText: Binding<String>,
        selectedMode: Binding<BraisenlySidebarMode>,
        theme: Binding<BraisenlyTheme>
    ) {
        self.documentTitle = documentTitle
        self.documentText = documentText
        _isSidebarOpen = isSidebarOpen
        _isActionSheetPresented = isActionSheetPresented
        _isContextPopoverOpen = isContextPopoverOpen
        _searchText = searchText
        _selectedMode = selectedMode
        _theme = theme
    }

    public var body: some View {
        GeometryReader { proxy in
            let sidebarWidth = proxy.size.width * BraisenlyDS.Metrics.sidebarWidthRatio
            ZStack(alignment: .leading) {
                BraisenlyDocumentCanvas(
                    title: documentTitle,
                    bodyText: documentText,
                    theme: $theme,
                    platform: .iPhone,
                    onToggleSidebar: toggleSidebar,
                    onOpenActionSheet: { isActionSheetPresented = true }
                )
                .offset(x: isSidebarOpen ? sidebarWidth : 0)
                .overlay {
                    if isSidebarOpen {
                        Color.black.opacity(0.38).ignoresSafeArea().onTapGesture(perform: closeSidebar)
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
