import SwiftUI

public struct BraisenlyDocumentCanvas: View {
    @Environment(\.braisenlyTheme) private var theme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    public let title: String
    public let bodyText: String
    public let platform: BraisenlyPlatform
    public let onToggleSidebar: () -> Void
    public let onEdit: () -> Void
    public let onOpenActionSheet: () -> Void
    @Binding private var themeID: BraisenlyThemeDefinition.ID

    public init(
        title: String = "Home",
        bodyText: String,
        theme: Binding<BraisenlyThemeDefinition.ID> = .constant(BraisenlyThemes.liquidGlass.id),
        platform: BraisenlyPlatform = .automatic,
        onToggleSidebar: @escaping () -> Void = {},
        onEdit: @escaping () -> Void = {},
        onOpenActionSheet: @escaping () -> Void = {}
    ) {
        self.title = title
        self.bodyText = bodyText
        _themeID = theme
        self.platform = platform
        self.onToggleSidebar = onToggleSidebar
        self.onEdit = onEdit
        self.onOpenActionSheet = onOpenActionSheet
    }

    public var body: some View {
        let resolvedPlatform = platform.resolved(horizontalSizeClass: horizontalSizeClass)
        ZStack {
            theme.colors.backgroundPrimary.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: theme.metrics.spacing[.l]) {
                    Text(title)
                        .font(theme.typography.documentTitle)
                        .foregroundStyle(theme.colors.accentTeal)
                    Text(bodyText)
                        .font(theme.typography.bodyReading)
                        .foregroundStyle(theme.colors.textPrimary)
                        .lineSpacing(4.5)
                }
                .frame(maxWidth: resolvedPlatform.contentMaxWidth, alignment: .leading)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, resolvedPlatform == .iPhone ? theme.metrics.spacing[.l] + theme.metrics.spacing[.xs] : theme.metrics.spacing[.xl] + theme.metrics.spacing[.s])
                .padding(.top, theme.metrics.spacing[.xl] * 3 + (resolvedPlatform == .mac ? theme.metrics.spacing[.s] : 0))
                .padding(.bottom, theme.metrics.toolbarHeight + theme.metrics.spacing[.xl] * 2)
            }
            BraisenlyDocumentChrome(
                theme: $themeID,
                platform: resolvedPlatform,
                onToggleSidebar: onToggleSidebar,
                onEdit: onEdit,
                onOpenActionSheet: onOpenActionSheet
            )
        }
    }
}
