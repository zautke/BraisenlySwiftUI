import SwiftUI
import Testing
@testable import BraisenlySwiftUI

private enum Tab: String, Hashable, CaseIterable { case a, b, c }

@Suite struct BraisenlySegmentedControlTests {
    @Test func segmentedControlStoresOptionsInOrder() {
        let control = BraisenlySegmentedControl(selection: .constant(Tab.a), options: [Tab.c, .a, .b], title: { $0.rawValue })
        #expect(control.options == [.c, .a, .b])
    }

    @MainActor @Test(arguments: BraisenlyThemes.all)
    func rendersInEveryTheme(theme: BraisenlyThemeDefinition) {
        let three = BraisenlySegmentedControl(selection: .constant(Tab.b), options: Tab.allCases, title: { $0.rawValue })
        #expect(RenderSmoke.renders(three, theme: theme))
        let empty = BraisenlySegmentedControl(selection: .constant(Tab.a), options: [Tab](), title: { $0.rawValue })
        #expect(RenderSmoke.renders(empty, theme: theme))
    }

    @MainActor @Test(arguments: BraisenlyThemes.all)
    func rendersAtAccessibility5(theme: BraisenlyThemeDefinition) {
        let three = BraisenlySegmentedControl(selection: .constant(Tab.b), options: Tab.allCases, title: { $0.rawValue })
        #expect(RenderSmoke.renders(three, theme: theme, dynamicType: .accessibility5))
    }
}
