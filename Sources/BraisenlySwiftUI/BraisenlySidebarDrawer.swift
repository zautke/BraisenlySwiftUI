import SwiftUI

public struct BraisenlySidebarDrawer: View {
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
        ZStack(alignment: .bottom) {
            BraisenlyDS.Colors.backgroundPrimary.ignoresSafeArea()
            VStack(spacing: 0) {
                BraisenlySidebarSearchHeader(searchText: $searchText, platform: resolvedPlatform)
                Divider().overlay(BraisenlyDS.Colors.divider)
                BraisenlySearchMetadataRow()
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        BraisenlyHighlightedText("applegriswald", highlight: searchText)
                        BraisenlyHighlightedText("griswalds", highlight: searchText)
                        BraisenlyExpandableSearchResult(
                            query: searchText,
                            platform: resolvedPlatform,
                            isExpanded: $isMatchExpanded
                        )
                    }
                    .padding(resolvedPlatform == .mac ? 12 : 16)
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
                .padding(.horizontal, 14)
                .padding(.bottom, resolvedPlatform == .mac ? 104 : 126)
                .transition(.scale(scale: 0.92, anchor: .bottom).combined(with: .opacity))
            }
        }
        .overlay(alignment: .trailing) {
            Rectangle().fill(BraisenlyDS.Colors.borderSubtle.opacity(0.4)).frame(width: 0.5).ignoresSafeArea()
        }
    }

    private func toggleContextPopover() {
        withAnimation(.spring(response: 0.28, dampingFraction: 0.82)) {
            isShowingContextPopover.toggle()
        }
    }
}
