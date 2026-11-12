import SwiftUI
import Testing
@testable import BraisenlySwiftUI

private let files = [
    "Sources/BraisenlySwiftUI/BraisenlyAvatarBadge.swift",
    "Sources/BraisenlySwiftUI/BraisenlyTabCounterBadge.swift",
    "Sources/BraisenlySwiftUI/BraisenlyPulseIndicator.swift",
    "Sources/BraisenlySwiftUI/BraisenlyHighlightedText.swift",
    "Sources/BraisenlySwiftUI/BraisenlyPromptField.swift",
    "Sources/BraisenlySwiftUI/BraisenlyKeyEntryField.swift",
    "Sources/BraisenlySwiftUI/BraisenlyParameterSliderRow.swift",
]

@Test func b2FilesHaveNoStaticTokensOrLiteralMetrics() throws {
    let v = try SourceScan.violations(in: files)
    #expect(v == [], "\(v)")
}

@Test func b2OverridesDefaultToNil() {
    #expect(BraisenlyAvatarBadge(systemName: "x").foregroundColor == nil)
    #expect(BraisenlyPromptField(text: .constant("")).cornerRadius == nil)
}

@MainActor @Test(arguments: BraisenlyThemes.all)
func b2ViewsRender(theme: BraisenlyThemeDefinition) {
    #expect(RenderSmoke.renders(BraisenlyAvatarBadge(systemName: "sparkles"), theme: theme))
    #expect(RenderSmoke.renders(BraisenlyTabCounterBadge(count: 3), theme: theme))
    #expect(RenderSmoke.renders(BraisenlyPulseIndicator(), theme: theme))
    #expect(RenderSmoke.renders(BraisenlyHighlightedText("hello world", highlight: "wor"), theme: theme))
    #expect(RenderSmoke.renders(BraisenlyPromptField(text: .constant("hi")), theme: theme))
    #expect(RenderSmoke.renders(BraisenlyKeyEntryField(title: "Key", text: .constant("")), theme: theme))
    #expect(RenderSmoke.renders(BraisenlyParameterSliderRow(title: "Temp", value: .constant(0.5)), theme: theme))
}
