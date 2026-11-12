import SwiftUI

public struct BraisenlySidebarSearchHeader: View {
    @Environment(\.braisenlyTheme) private var theme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Binding private var searchText: String
    public let platform: BraisenlyPlatform

    public init(searchText: Binding<String>, platform: BraisenlyPlatform = .automatic) {
        _searchText = searchText
        self.platform = platform
    }

    public var body: some View {
        let resolvedPlatform = platform.resolved(horizontalSizeClass: horizontalSizeClass)
        HStack(spacing: theme.metrics.spacing[.m]) {
            HStack(spacing: theme.metrics.spacing[.s]) {
                Image(systemName: "magnifyingglass")
                TextField("Search…", text: $searchText)
                    .textFieldStyle(.plain)
                Text("Aa")
                Button { searchText = "" } label: { Image(systemName: "xmark.circle.fill") }
                    .accessibilityLabel("Clear search")
            }
            .foregroundStyle(theme.colors.textSecondary)
            .padding(.horizontal, theme.metrics.spacing[.m])
            .frame(height: resolvedPlatform == .mac ? 34 : 42)
            .braisenlyCapsule(fill: theme.colors.surfaceSheet, role: .chrome)
            Button {} label: { Image(systemName: "slider.horizontal.3").frame(width: 36, height: 42) }
                .buttonStyle(.plain)
                .accessibilityLabel("Search filters")
        }
        .padding(.horizontal, resolvedPlatform == .mac ? theme.metrics.spacing[.m] : theme.metrics.spacing[.l])
        .padding(.vertical, resolvedPlatform == .mac ? theme.metrics.spacing[.s] : theme.metrics.spacing[.m])
    }
}
