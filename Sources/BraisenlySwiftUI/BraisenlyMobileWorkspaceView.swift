import SwiftUI

/// Self-contained workspace. With no `initialTheme` it uses and follows the environment theme;
/// a passed `initialTheme` (or a pick in its own theme switcher) overrides it.
public struct BraisenlyMobileWorkspaceView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.braisenlyTheme) private var environmentTheme
    @State private var isSidebarOpen = false
    @State private var isActionSheetPresented = false
    @State private var isContextPopoverOpen = false
    @State private var searchText = "gris"
    @State private var selectedMode = BraisenlySidebarMode.search
    /// nil = follow the environment theme; set by `initialTheme` or the in-workspace switcher.
    @State private var themeOverride: BraisenlyThemeDefinition.ID?

    public let documentTitle: String
    public let documentText: String
    public let platform: BraisenlyPlatform

    public init(
        documentTitle: String = "Home",
        documentText: String = BraisenlyMobileWorkspaceView.sampleText,
        initialTheme: BraisenlyThemeDefinition.ID? = nil,
        platform: BraisenlyPlatform = .automatic
    ) {
        self.documentTitle = documentTitle
        self.documentText = documentText
        self.platform = platform
        _themeOverride = State(initialValue: initialTheme)
    }

    public var body: some View {
        let resolvedPlatform = platform.resolved(horizontalSizeClass: horizontalSizeClass)
        let theme = Self.resolvedTheme(override: themeOverride, environment: environmentTheme)
        let themeID = Binding(
            get: { themeOverride ?? environmentTheme.id },
            set: { themeOverride = $0 }
        )
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
                    theme: themeID
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
                    theme: themeID
                )
            }
        }
        .braisenlyTheme(theme)
        .sheet(isPresented: $isActionSheetPresented) {
            BraisenlyDocumentActionSheet(platform: resolvedPlatform)
                .presentationDetents(resolvedPlatform == .mac ? [.large] : [.fraction(0.76), .large])
                .presentationDragIndicator(.hidden)
                .braisenlySheetBackground()
                .braisenlyTheme(theme)
        }
    }

    /// Override id (unknown ids fall back per `BraisenlyThemes.theme(withID:)`), else the environment theme.
    static func resolvedTheme(
        override: BraisenlyThemeDefinition.ID?,
        environment: BraisenlyThemeDefinition
    ) -> BraisenlyThemeDefinition {
        override.map { BraisenlyThemes.theme(withID: $0) } ?? environment
    }

    public static let sampleText = "Braisenly is a focused workspace for connected notes, research, and ideas. Use this reusable canvas as a starting point, or provide your own document title and content."
}
