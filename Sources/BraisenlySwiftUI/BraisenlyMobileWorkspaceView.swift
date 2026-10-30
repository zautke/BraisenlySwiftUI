import SwiftUI

public struct BraisenlyMobileWorkspaceView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var isSidebarOpen = false
    @State private var isActionSheetPresented = false
    @State private var isContextPopoverOpen = false
    @State private var searchText = "gris"
    @State private var selectedMode = BraisenlySidebarMode.search
    @State private var theme: BraisenlyTheme

    public let documentTitle: String
    public let documentText: String
    public let platform: BraisenlyPlatform

    public init(
        documentTitle: String = "Home",
        documentText: String = BraisenlyMobileWorkspaceView.sampleText,
        initialTheme: BraisenlyTheme = .dark,
        platform: BraisenlyPlatform = .automatic
    ) {
        self.documentTitle = documentTitle
        self.documentText = documentText
        self.platform = platform
        _theme = State(initialValue: initialTheme)
    }

    public var body: some View {
        let resolvedPlatform = platform.resolved(horizontalSizeClass: horizontalSizeClass)
        Group {
            if resolvedPlatform == .iPhone {
                BraisenlyCompactWorkspace(
                    documentTitle: documentTitle,
                    documentText: documentText,
                    isSidebarOpen: $isSidebarOpen,
                    isActionSheetPresented: $isActionSheetPresented,
                    isContextPopoverOpen: $isContextPopoverOpen,
                    searchText: $searchText,
                    selectedMode: $selectedMode,
                    theme: $theme
                )
            } else {
                BraisenlyRegularWorkspace(
                    documentTitle: documentTitle,
                    documentText: documentText,
                    platform: resolvedPlatform,
                    isActionSheetPresented: $isActionSheetPresented,
                    isContextPopoverOpen: $isContextPopoverOpen,
                    searchText: $searchText,
                    selectedMode: $selectedMode,
                    theme: $theme
                )
            }
        }
        .braisenlyTheme(theme)
        .sheet(isPresented: $isActionSheetPresented) {
            BraisenlyDocumentActionSheet(platform: resolvedPlatform)
                .presentationDetents(resolvedPlatform == .mac ? [.large] : [.fraction(0.76), .large])
                .presentationDragIndicator(.hidden)
                .presentationCornerRadius(28)
                .presentationBackground(BraisenlyDS.Colors.surfaceSheet)
        }
    }

    public static let sampleText = "Braisenly is a focused workspace for connected notes, research, and ideas. Use this reusable canvas as a starting point, or provide your own document title and content."
}
