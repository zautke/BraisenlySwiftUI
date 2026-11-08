import SwiftUI

public struct BraisenlySidebarSearchHeader: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Binding private var searchText: String
    public let platform: BraisenlyPlatform

    public init(searchText: Binding<String>, platform: BraisenlyPlatform = .automatic) {
        _searchText = searchText
        self.platform = platform
    }

    public var body: some View {
        let resolvedPlatform = platform.resolved(horizontalSizeClass: horizontalSizeClass)
        HStack(spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                TextField("Search…", text: $searchText)
                    .textFieldStyle(.plain)
                Text("Aa")
                Button { searchText = "" } label: { Image(systemName: "xmark.circle.fill") }
                    .accessibilityLabel("Clear search")
            }
            .foregroundStyle(BraisenlyDS.Colors.textSecondary)
            .padding(.horizontal, 14)
            .frame(height: resolvedPlatform == .mac ? 34 : 42)
            .braisenlyCapsule(fill: BraisenlyDS.Colors.surfaceSheet)
            Button {} label: { Image(systemName: "slider.horizontal.3").frame(width: 36, height: 42) }
                .buttonStyle(.plain)
                .accessibilityLabel("Search filters")
        }
        .padding(.horizontal, resolvedPlatform == .mac ? 12 : 16)
        .padding(.vertical, resolvedPlatform == .mac ? 10 : 14)
    }
}
