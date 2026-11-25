import SwiftUI
import Testing
@testable import BraisenlySwiftUI

@Suite struct BraisenlyHighlightedTextTests {
    private func pairs(_ text: String, _ highlight: String) -> [String] {
        BraisenlyHighlightedTextSegment.make(text: text, highlight: highlight)
            .map { $0.isMatch ? "[\($0.text)]" : $0.text }
    }

    @Test func multipleMatches() {
        #expect(pairs("glass and glass", "glass") == ["[glass]", " and ", "[glass]"])
    }

    @Test func caseInsensitiveMatchKeepsOriginalCase() {
        #expect(pairs("Liquid Glass, glass-free", "GLASS") == ["Liquid ", "[Glass]", ", ", "[glass]", "-free"])
    }

    @Test func emptyQueryHighlightsNothing() {
        #expect(pairs("applegriswald", "") == ["applegriswald"])
    }

    @Test func queryNotFound() {
        #expect(pairs("applegriswald", "zzz") == ["applegriswald"])
    }

    @Test func matchAtStartAndEnd() {
        #expect(pairs("griswalds", "gris") == ["[gris]", "walds"])
        #expect(pairs("applegris", "gris") == ["apple", "[gris]"])
        #expect(pairs("gris", "gris") == ["[gris]"])
    }

    @Test func segmentsReassembleTextInOrderWithUniqueIDs() {
        let text = "…a cut of gristled beef from its rough-hewn, lowly beginnings…"
        let segments = BraisenlyHighlightedTextSegment.make(text: text, highlight: "gris")
        #expect(segments.map(\.text).joined() == text)
        #expect(Set(segments.map(\.id)).count == segments.count)
    }

    @MainActor @Test(arguments: BraisenlyThemes.all)
    func rendersInEveryTheme(theme: BraisenlyThemeDefinition) {
        #expect(RenderSmoke.renders(BraisenlyHighlightedText("Liquid Glass is glass", highlight: "glass"), theme: theme))
        #expect(RenderSmoke.renders(BraisenlyHighlightedText("no match", highlight: ""), theme: theme))
    }
}
