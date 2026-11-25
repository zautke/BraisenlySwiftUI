import SwiftUI
import Testing
@testable import BraisenlySwiftUI

@Suite struct BraisenlyTextFieldRowTests {
    @Test func textFieldRowDefaults() {
        let row = BraisenlyTextFieldRow("Name", text: .constant(""))
        #expect(row.title == "Name")
        #expect(row.prompt == "")
        #expect(row.axis == .horizontal)
    }

    @MainActor @Test(arguments: BraisenlyThemes.all)
    func captionNeverBelowMetadataOrElevenPoints(theme: BraisenlyThemeDefinition) {
        let context = EnvironmentValues().fontResolutionContext
        let size = BraisenlyTextFieldRow.captionFont(theme).resolve(in: context).pointSize
        #expect(size >= theme.typography.metadata.resolve(in: context).pointSize)
        #expect(size >= 11)
    }

    @MainActor @Test(arguments: BraisenlyThemes.all)
    func rendersInEveryTheme(theme: BraisenlyThemeDefinition) {
        #expect(RenderSmoke.renders(BraisenlyTextFieldRow("Name", text: .constant("Ada"), prompt: "Your name"), theme: theme))
        let five = "one\ntwo\nthree\nfour\nfive"
        #expect(RenderSmoke.renders(BraisenlyTextFieldRow("Notes", text: .constant(five), axis: .vertical), theme: theme))
    }
}
