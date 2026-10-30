import SwiftUI

public enum BraisenlySidebarMode: String, CaseIterable, Identifiable, Sendable {
    case files = "Files"
    case search = "Search"
    case tags = "Tags"
    case bookmarks = "Bookmarks"
    case allProperties = "All properties"

    public var id: Self { self }

    public var icon: String {
        switch self {
        case .files: "folder"
        case .search: "magnifyingglass"
        case .tags: "tag"
        case .bookmarks: "bookmark"
        case .allProperties: "archivebox"
        }
    }
}

public struct BraisenlySearchSnippetCard: View {
    public let text: String
    public let query: String

    public init(text: String, query: String) {
        self.text = text
        self.query = query
    }

    public var body: some View {
        BraisenlyHighlightedText(
            text,
            highlight: query,
            font: BraisenlyDS.Typography.snippetBody
        )
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .braisenlyCard(cornerRadius: BraisenlyDS.Metrics.snippetRadius, fill: BraisenlyDS.Colors.surfaceSnippet)
    }
}

public struct BraisenlySidebarContextPopover: View {
    @Binding private var selectedMode: BraisenlySidebarMode
    @Binding private var isPresented: Bool

    public init(selectedMode: Binding<BraisenlySidebarMode>, isPresented: Binding<Bool>) {
        _selectedMode = selectedMode
        _isPresented = isPresented
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            ForEach(BraisenlySidebarMode.allCases) { mode in
                Button {
                    selectedMode = mode
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.85)) { isPresented = false }
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: mode.icon).frame(width: 24)
                        Text(mode.rawValue)
                            .font(BraisenlyDS.Typography.rowLabelMedium)
                        Spacer()
                    }
                    .foregroundStyle(BraisenlyDS.Colors.textBright)
                    .padding(.horizontal, 14)
                    .frame(height: 44)
                    .background {
                        if mode == selectedMode {
                            Capsule(style: .continuous).fill(BraisenlyDS.Colors.surfaceHighlight)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(10)
        .braisenlyCard(cornerRadius: BraisenlyDS.Metrics.popoverRadius)
        .shadow(color: .black.opacity(0.45), radius: 20, x: 0, y: 8)
    }
}

public struct BraisenlySidebarDrawer: View {
    @Binding private var searchText: String
    @Binding private var selectedMode: BraisenlySidebarMode
    @Binding private var isShowingContextPopover: Bool
    @State private var isMatchExpanded = true

    public init(
        searchText: Binding<String>,
        selectedMode: Binding<BraisenlySidebarMode>,
        isShowingContextPopover: Binding<Bool>
    ) {
        _searchText = searchText
        _selectedMode = selectedMode
        _isShowingContextPopover = isShowingContextPopover
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            BraisenlyDS.Colors.backgroundPrimary.ignoresSafeArea()
            VStack(spacing: 0) {
                BraisenlySidebarSearchHeader(searchText: $searchText)
                Divider().overlay(BraisenlyDS.Colors.divider)
                BraisenlySearchMetadataRow()
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        BraisenlyHighlightedText("applegriswald", highlight: searchText)
                        BraisenlyHighlightedText("griswalds", highlight: searchText)
                        BraisenlyExpandableSearchResult(
                            query: searchText,
                            isExpanded: $isMatchExpanded
                        )
                    }
                    .padding(16)
                }
                BraisenlySidebarFooter(
                    selectedMode: selectedMode,
                    onModePickerTap: {
                        withAnimation(.spring(response: 0.28, dampingFraction: 0.82)) {
                            isShowingContextPopover.toggle()
                        }
                    }
                )
            }
            if isShowingContextPopover {
                BraisenlySidebarContextPopover(selectedMode: $selectedMode, isPresented: $isShowingContextPopover)
                    .padding(.horizontal, 14)
                    .padding(.bottom, 126)
                    .transition(.scale(scale: 0.92, anchor: .bottom).combined(with: .opacity))
            }
        }
        .overlay(alignment: .trailing) {
            Rectangle().fill(BraisenlyDS.Colors.borderSubtle.opacity(0.4)).frame(width: 0.5).ignoresSafeArea()
        }
    }
}

private struct BraisenlySidebarSearchHeader: View {
    @Binding var searchText: String

    var body: some View {
        HStack(spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                TextField("Search…", text: $searchText)
                Text("Aa")
                Button { searchText = "" } label: { Image(systemName: "xmark.circle.fill") }
                    .accessibilityLabel("Clear search")
            }
            .foregroundStyle(BraisenlyDS.Colors.textSecondary)
            .padding(.horizontal, 14)
            .frame(height: 42)
            .braisenlyCapsule(fill: BraisenlyDS.Colors.surfaceSheet)
            Button {} label: { Image(systemName: "slider.horizontal.3").frame(width: 36, height: 42) }
                .accessibilityLabel("Search filters")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

private struct BraisenlySearchMetadataRow: View {
    var body: some View {
        HStack {
            Text("3 results")
            Spacer()
            Label("File name (A to Z)", systemImage: "chevron.up.chevron.down")
        }
        .font(BraisenlyDS.Typography.metadata)
        .foregroundStyle(BraisenlyDS.Colors.textSecondary)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

private struct BraisenlyExpandableSearchResult: View {
    let query: String
    @Binding var isExpanded: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button { withAnimation(.snappy) { isExpanded.toggle() } } label: {
                HStack {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                    Text("Independence and chicken-fried steak").lineLimit(1)
                    Spacer()
                    Text("1")
                }
                .foregroundStyle(BraisenlyDS.Colors.textPrimary)
            }
            .buttonStyle(.plain)
            if isExpanded {
                BraisenlySearchSnippetCard(
                    text: "…you with a recipe for this dish, which through hard work and culinary ingenuity catapults a cut of gristled beef from its rough-hewn, lowly beginnings to delectable and iconic heights…",
                    query: query
                )
                .padding(.leading, 12)
            }
        }
    }
}

private struct BraisenlySidebarFooter: View {
    let selectedMode: BraisenlySidebarMode
    let onModePickerTap: () -> Void

    var body: some View {
        VStack(spacing: 14) {
            Button(action: onModePickerTap) {
                HStack {
                    Image(systemName: selectedMode.icon)
                    Text(selectedMode.rawValue)
                    Spacer()
                    Image(systemName: "chevron.up.chevron.down")
                }
                .padding(.horizontal, 18)
                .frame(height: 48)
                .braisenlyCapsule()
            }
            .buttonStyle(.plain)
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Braisenly").font(BraisenlyDS.Typography.vaultTitle)
                    Text("1,002 files, 327 folders").font(BraisenlyDS.Typography.metadata)
                }
                Spacer()
                BraisenlyCircleIconButton(systemName: "gearshape", accessibilityLabel: "Settings") {}
            }
        }
        .foregroundStyle(BraisenlyDS.Colors.textPrimary)
        .padding(.horizontal, 14)
        .padding(.bottom, 12)
    }
}
