import SwiftUI

public struct BraisenlyDocumentCanvas: View {
    public let title: String
    public let bodyText: String
    public let onToggleSidebar: () -> Void
    public let onEdit: () -> Void
    public let onOpenActionSheet: () -> Void

    public init(
        title: String = "Home",
        bodyText: String,
        onToggleSidebar: @escaping () -> Void = {},
        onEdit: @escaping () -> Void = {},
        onOpenActionSheet: @escaping () -> Void = {}
    ) {
        self.title = title
        self.bodyText = bodyText
        self.onToggleSidebar = onToggleSidebar
        self.onEdit = onEdit
        self.onOpenActionSheet = onOpenActionSheet
    }

    public var body: some View {
        ZStack {
            BraisenlyDS.Colors.backgroundPrimary.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text(title)
                        .font(BraisenlyDS.Typography.documentTitle)
                        .foregroundStyle(BraisenlyDS.Colors.accentTeal)
                    Text(bodyText)
                        .font(BraisenlyDS.Typography.bodyReading)
                        .foregroundStyle(BraisenlyDS.Colors.textPrimary)
                        .lineSpacing(4.5)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 74)
                .padding(.bottom, 110)
            }
            VStack {
                HStack {
                    BraisenlyCircleIconButton(
                        systemName: "sidebar.left",
                        accessibilityLabel: "Toggle sidebar",
                        action: onToggleSidebar
                    )
                    Spacer()
                    BraisenlyDualActionPill(onEdit: onEdit, onMore: onOpenActionSheet)
                }
                .padding(.horizontal, 16)
                .padding(.top, 6)
                Spacer()
                BraisenlyBottomToolbar(onSearch: onToggleSidebar, onMenu: onOpenActionSheet)
                    .padding(.bottom, 12)
            }
        }
    }
}

public struct BraisenlyMobileWorkspaceView: View {
    @State private var isSidebarOpen = false
    @State private var isActionSheetPresented = false
    @State private var isContextPopoverOpen = false
    @State private var searchText = "gris"
    @State private var selectedMode = BraisenlySidebarMode.search

    public let documentTitle: String
    public let documentText: String

    public init(documentTitle: String = "Home", documentText: String = BraisenlyMobileWorkspaceView.sampleText) {
        self.documentTitle = documentTitle
        self.documentText = documentText
    }

    public var body: some View {
        GeometryReader { proxy in
            let sidebarWidth = proxy.size.width * BraisenlyDS.Metrics.sidebarWidthRatio
            ZStack(alignment: .leading) {
                BraisenlyDocumentCanvas(
                    title: documentTitle,
                    bodyText: documentText,
                    onToggleSidebar: toggleSidebar,
                    onOpenActionSheet: { isActionSheetPresented = true }
                )
                .offset(x: isSidebarOpen ? sidebarWidth : 0)
                .overlay {
                    if isSidebarOpen {
                        Color.black.opacity(0.38)
                            .ignoresSafeArea()
                            .onTapGesture { closeSidebar() }
                    }
                }
                if isSidebarOpen {
                    BraisenlySidebarDrawer(
                        searchText: $searchText,
                        selectedMode: $selectedMode,
                        isShowingContextPopover: $isContextPopoverOpen
                    )
                    .frame(width: sidebarWidth)
                    .transition(.move(edge: .leading))
                }
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $isActionSheetPresented) {
            BraisenlyDocumentActionSheet()
                .presentationDetents([.fraction(0.76), .large])
                .presentationDragIndicator(.hidden)
                .presentationCornerRadius(28)
                .presentationBackground(BraisenlyDS.Colors.surfaceSheet)
        }
    }

    public static let sampleText = "Braisenly is a focused workspace for connected notes, research, and ideas. Use this reusable canvas as a starting point, or provide your own document title and content."

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
