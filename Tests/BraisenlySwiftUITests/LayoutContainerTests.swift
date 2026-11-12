import SwiftUI
import Testing
@testable import BraisenlySwiftUI

@Test func containerDefaults() {
    #expect(BraisenlyScroll { EmptyView() }.axes == .vertical)
    #expect(BraisenlyGrid { EmptyView() }.minimumColumnWidth == 160)
    #expect(BraisenlyGrid { EmptyView() }.spacing == .m)
    #expect(BraisenlySplitView(sidebar: { EmptyView() }, detail: { EmptyView() }).extendsDetailBackground == false)
}

@MainActor @Test(arguments: BraisenlyThemes.all)
func containersRender(theme: BraisenlyThemeDefinition) {
    let view = BraisenlySplitView(extendsDetailBackground: true) {
        Text("sidebar")
    } detail: {
        BraisenlyScroll {
            BraisenlyGrid { ForEach(0..<12, id: \.self) { Text("Item \($0)") } }
        }
    }
    #expect(RenderSmoke.renders(view, theme: theme, size: CGSize(width: 1024, height: 768)))
}
