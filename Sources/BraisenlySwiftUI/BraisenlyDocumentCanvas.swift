import SwiftUI

public struct BraisenlyDocumentCanvas: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    public let title: String
    public let bodyText: String
    public let platform: BraisenlyPlatform
    public let onToggleSidebar: () -> Void
    public let onEdit: () -> Void
    public let onOpenActionSheet: () -> Void
    @Binding private var theme: BraisenlyTheme

    public init(
        title: String = "Home",
        bodyText: String,
        theme: Binding<BraisenlyTheme> = .constant(.dark),
        platform: BraisenlyPlatform = .automatic,
        onToggleSidebar: @escaping () -> Void = {},
        onEdit: @escaping () -> Void = {},
        onOpenActionSheet: @escaping () -> Void = {}
    ) {
        self.title = title
        self.bodyText = bodyText
        _theme = theme
        self.platform = platform
        self.onToggleSidebar = onToggleSidebar
        self.onEdit = onEdit
        self.onOpenActionSheet = onOpenActionSheet
    }

    public var body: some View {
        let resolvedPlatform = platform.resolved(horizontalSizeClass: horizontalSizeClass)
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
                .frame(maxWidth: resolvedPlatform.contentMaxWidth, alignment: .leading)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, resolvedPlatform == .iPhone ? 20 : 32)
                .padding(.top, resolvedPlatform == .mac ? 82 : 74)
                .padding(.bottom, 110)
            }
            BraisenlyDocumentChrome(
                theme: $theme,
                platform: resolvedPlatform,
                onToggleSidebar: onToggleSidebar,
                onEdit: onEdit,
                onOpenActionSheet: onOpenActionSheet
            )
        }
    }
}
