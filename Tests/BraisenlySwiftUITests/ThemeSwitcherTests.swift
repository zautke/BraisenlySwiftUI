import SwiftUI
import Testing
@testable import BraisenlySwiftUI

@Suite struct ThemeSwitcherTests {
    @Test func defaultsToAllThemesInRowStyle() {
        let s = BraisenlyThemeSwitcher(selection: .constant("liquidGlass"))
        #expect(s.themes.map(\.id) == BraisenlyThemes.all.map(\.id))
        #expect(s.style == .row)
        #expect(s.platform == .automatic)
    }

    @Test func nextIDWrapsAndUnknownFallsBackToFirst() {
        #expect(BraisenlyThemes.nextID(after: "solarizedDark") == "liquidGlass")
        #expect(BraisenlyThemes.nextID(after: "nope") == "liquidGlass")
    }

    @MainActor @Test(arguments: BraisenlyThemes.all)
    func rendersBothStylesAndUnknownSelection(theme: BraisenlyThemeDefinition) {
        #expect(RenderSmoke.renders(BraisenlyThemeSwitcher(selection: .constant(theme.id)), theme: theme))
        #expect(RenderSmoke.renders(BraisenlyThemeSwitcher(selection: .constant(theme.id), style: .cycle), theme: theme))
        #expect(RenderSmoke.renders(BraisenlyThemeSwitcher(selection: .constant("nope")), theme: theme))
        #expect(RenderSmoke.renders(BraisenlyThemeSwitcher(selection: .constant("nope"), style: .cycle), theme: theme))
    }
}
