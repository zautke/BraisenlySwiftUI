import SwiftUI
import Testing
@testable import BraisenlySwiftUI

@Suite struct BraisenlyPropertyTableTests {
    @Test func rowIdIsKey() {
        #expect(BraisenlyPropertyTable.Row(key: "size", value: "32").id == "size")
    }

    @MainActor @Test(arguments: BraisenlyThemes.all)
    func keyNeverBelowMetadataOrElevenPoints(theme: BraisenlyThemeDefinition) {
        let context = EnvironmentValues().fontResolutionContext
        let size = BraisenlyPropertyTable.keyFont(theme).resolve(in: context).pointSize
        #expect(size >= theme.typography.metadata.resolve(in: context).pointSize)
        #expect(size >= 11)
    }

    @MainActor @Test(arguments: BraisenlyThemes.all)
    func valueNeverBelowMetadataOrElevenPoints(theme: BraisenlyThemeDefinition) {
        let context = EnvironmentValues().fontResolutionContext
        let size = BraisenlyPropertyTable.valueFont(theme).resolve(in: context).pointSize
        #expect(size >= theme.typography.metadata.resolve(in: context).pointSize)
        #expect(size >= 11)
    }

    @MainActor @Test func valueStaysMonospaced() {
        let theme = BraisenlyThemes.solarizedLight
        #expect(BraisenlyPropertyTable.valueFont(theme).resolve(in: EnvironmentValues().fontResolutionContext).isMonospaced)
    }

    @MainActor @Test(arguments: BraisenlyThemes.all)
    func rendersInEveryTheme(theme: BraisenlyThemeDefinition) {
        let rows = ["size", "radius", "weight", "tint"].map { BraisenlyPropertyTable.Row(key: $0, value: "v") }
        #expect(RenderSmoke.renders(BraisenlyPropertyTable(rows: rows), theme: theme))
        #expect(RenderSmoke.renders(BraisenlyPropertyTable(rows: []), theme: theme))
    }
}
