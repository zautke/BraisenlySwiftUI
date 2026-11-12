import SwiftUI
import Testing
@testable import BraisenlySwiftUI

@Suite struct BraisenlyChipGroupTests {
    @Test func flowPacksGreedily() {
        let s = CGSize(width: 40, height: 20)
        #expect(BraisenlyFlowLayout.rows(for: [s, s, s], maxWidth: 100, spacing: 8) == [[0, 1], [2]])
        #expect(BraisenlyFlowLayout.rows(for: [CGSize(width: 300, height: 20), s], maxWidth: 100, spacing: 8) == [[0], [1]])
        #expect(BraisenlyFlowLayout.rows(for: [], maxWidth: 100, spacing: 8) == [])
    }

    @MainActor @Test(arguments: BraisenlyThemes.all)
    func rendersInEveryTheme(theme: BraisenlyThemeDefinition) {
        let many = (0..<12).map { "option \($0)" }
        #expect(RenderSmoke.renders(
            BraisenlyChipGroup(selection: .constant("option 3"), options: many, title: { $0 }),
            theme: theme
        ))
        #expect(RenderSmoke.renders(
            BraisenlyChipGroup(selection: .constant(""), options: [String](), title: { $0 }),
            theme: theme
        ))
    }
}
