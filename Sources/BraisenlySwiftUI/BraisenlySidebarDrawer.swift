import SwiftUI

public struct BraisenlySidebarDrawer: View {
    @Environment(\.braisenlyTheme) private var theme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Binding private var searchText: String
    @Binding private var selectedMode: BraisenlySidebarMode
    @Binding private var isShowingContextPopover: Bool
    @State private var isMatchExpanded = true

    public let platform: BraisenlyPlatform

    public init(
        searchText: Binding<String>,
        selectedMode: Binding<BraisenlySidebarMode>,
        isShowingContextPopover: Binding<Bool>,
        platform: BraisenlyPlatform = .automatic
    ) {
        _searchText = searchText
        _selectedMode = selectedMode
        _isShowingContextPopover = isShowingContextPopover
        self.platform = platform
    }

    public var body: some View {
        let resolvedPlatform = platform.resolved(horizontalSizeClass: horizontalSizeClass)
        BraisenlyGlassGroup {
            ZStack(alignment: .bottom) {
                theme.colors.backgroundPrimary.ignoresSafeArea()
                VStack(spacing: 0) {
                    BraisenlySidebarSearchHeader(searchText: $searchText, platform: resolvedPlatform)
                    Divider().overlay(theme.colors.divider)
                    BraisenlySearchMetadataRow()
                    ScrollView {
                        VStack(alignment: .leading, spacing: theme.metrics.spacing[.l]) {
                            BraisenlyHighlightedText("applegriswald", highlight: searchText)
                            BraisenlyHighlightedText("griswalds", highlight: searchText)
                            BraisenlyExpandableSearchResult(
                                query: searchText,
                                platform: resolvedPlatform,
                                isExpanded: $isMatchExpanded
                            )
                        }
                        .padding(resolvedPlatform == .mac ? theme.metrics.spacing[.m] : theme.metrics.spacing[.l])
                    }
                    BraisenlySidebarFooter(
                        selectedMode: selectedMode,
                        platform: resolvedPlatform,
                        onModePickerTap: toggleContextPopover
                    )
                }
                if isShowingContextPopover {
                    BraisenlySidebarContextPopover(
                        selectedMode: $selectedMode,
                        isPresented: $isShowingContextPopover,
                        platform: resolvedPlatform
                    )
                    .padding(.horizontal, theme.metrics.spacing[.m])
                    .padding(.bottom, footerClearance(resolvedPlatform))
                    .transition(.scale(scale: 0.92, anchor: .bottom).combined(with: .opacity))
                }
            }
            .overlay(alignment: .trailing) {
                Rectangle().fill(theme.colors.borderSubtle.opacity(0.4)).frame(width: theme.metrics.hairline).ignoresSafeArea()
            }
        }
    }

    /// Footer height: mode capsule + settings button + inner spacing and bottom inset (mac 104, iPhone 120, iPad 128; was 104/126/126).
    private func footerClearance(_ platform: BraisenlyPlatform) -> CGFloat {
        platform.rowHeight + platform.controlSize + theme.metrics.spacing[.m] + theme.metrics.spacing[.l]
    }

    private func toggleContextPopover() {
        withAnimation(.spring(response: 0.28, dampingFraction: 0.82)) {
            isShowingContextPopover.toggle()
        }
    }
}
