import SwiftUI

private struct BraisenlySheetBackgroundModifier: ViewModifier {
    @Environment(\.braisenlyTheme) private var theme

    @ViewBuilder
    func body(content: Content) -> some View {
        let rounded = content.presentationCornerRadius(theme.metrics.sheetCornerRadius)
        if theme.surface == .solid {
            rounded.presentationBackground(theme.colors.surfaceSheet)
        } else {
            rounded
        }
    }
}

public extension View {
    /// Sheet presentation styling: `presentationCornerRadius(theme.metrics.sheetCornerRadius)`;
    /// solid themes also get `presentationBackground(theme.colors.surfaceSheet)`,
    /// glass themes keep the system glass sheet.
    func braisenlySheetBackground() -> some View {
        modifier(BraisenlySheetBackgroundModifier())
    }
}
