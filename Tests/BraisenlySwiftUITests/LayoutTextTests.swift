import SwiftUI
import Testing
@testable import BraisenlySwiftUI

@Test func everyTextStyleMapsToItsToken() {
    let t = BraisenlyTypographyTokens.standard
    let map: [BraisenlyTextStyle: Font] = [.documentTitle: t.documentTitle, .vaultTitle: t.vaultTitle,
        .bodyReading: t.bodyReading, .rowLabel: t.rowLabel, .rowLabelMedium: t.rowLabelMedium,
        .snippetBody: t.snippetBody, .metadata: t.metadata, .badgeNumber: t.badgeNumber,
        .code: t.code, .labelEmphasis: t.labelEmphasis, .chipLabel: t.chipLabel]
    #expect(map.count == BraisenlyTextStyle.allCases.count)
    for style in BraisenlyTextStyle.allCases { #expect(style.font(in: t) == map[style]) }
}

@Test func tonesMapToColorTokens() {
    let c = BraisenlyThemes.solarizedDark.colors
    #expect(BraisenlyTone.accent.color(in: c) == c.accentTeal)
    #expect(BraisenlyTone.danger.color(in: c) == c.danger)
    #expect(BraisenlyTone.secondary.color(in: c) == c.textSecondary)
}

@Test func iconSizesMapToTypography() {
    let t = BraisenlyTypographyTokens.standard
    #expect(BraisenlyIconSize.small.font(in: t) == t.chipLabel)
    #expect(BraisenlyIconSize.medium.font(in: t) == t.rowIcon)
    #expect(BraisenlyIconSize.large.font(in: t) == t.controlIcon)
}

@MainActor @Test(arguments: BraisenlyThemes.all)
func textAndIconRender(theme: BraisenlyThemeDefinition) {
    let dynamic: String = "dynamic"
    #expect(RenderSmoke.renders(VStack { BraisenlyText("Title", style: .vaultTitle); BraisenlyText(dynamic, tone: .secondary)
        BraisenlyIcon(systemName: "star", size: .large, tone: .accent) }, theme: theme, dynamicType: .accessibility5))
}
