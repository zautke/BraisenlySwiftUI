import SwiftUI
import Testing
@testable import BraisenlySwiftUI

@Test func stacksDefaultToMediumSpacing() {
    #expect(BraisenlyVStack { EmptyView() }.spacing == .m)
    #expect(BraisenlyHStack(spacing: .xl) { EmptyView() }.spacing == .xl)
    #expect(BraisenlySpacer().minLength == nil)
}

@MainActor @Test(arguments: BraisenlyThemes.all)
func layoutPrimitivesRender(theme: BraisenlyThemeDefinition) {
    let v = BraisenlyVStack {
        BraisenlyHStack { Text("a"); BraisenlySpacer(minLength: .s); Text("b") }
        BraisenlyDivider()
        BraisenlyZStack { Text("z") }.braisenlyPadding(.horizontal, .l)
    }
    #expect(RenderSmoke.renders(v, theme: theme))
}
