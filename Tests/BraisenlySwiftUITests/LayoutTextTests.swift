import SwiftUI
import Testing
@testable import BraisenlySwiftUI

/// Fixtures with a distinct value per token, so a swapped case cannot pass.
private enum Distinct {
    static let fonts: [Font] = [
        .system(size: 10), .system(size: 11), .system(size: 12), .system(size: 13), .system(size: 14),
        .system(size: 15), .system(size: 16), .system(size: 17), .system(size: 18), .system(size: 19),
        .system(size: 20), .system(size: 21), .system(size: 22), .system(size: 23),
    ]
    static let typography = BraisenlyTypographyTokens(
        documentTitle: fonts[0], vaultTitle: fonts[1], bodyReading: fonts[2], rowLabel: fonts[3],
        rowLabelMedium: fonts[4], snippetBody: fonts[5], metadata: fonts[6], badgeNumber: fonts[7],
        code: fonts[8], labelEmphasis: fonts[9], chipLabel: fonts[10], rowIcon: fonts[11],
        controlIcon: fonts[12], controlIconEmphasis: fonts[13])
    static func color(_ i: Double) -> Color { Color(red: i / 100, green: 0, blue: 0) }
    static let colors = BraisenlyColorTokens(
        backgroundPrimary: color(1), backgroundDimmed: color(2), surfaceSheet: color(3), surfaceElevated: color(4),
        surfaceHighlight: color(5), surfaceSnippet: color(6), borderSubtle: color(7), divider: color(8),
        accentTeal: color(9), textPrimary: color(10), textBright: color(11), textSecondary: color(12),
        textDisabled: color(13), matchBackground: color(14), matchForeground: color(15), danger: color(16),
        warning: color(17), success: color(18), scrim: color(19), shadow: color(20))
}

@Test func everyTextStyleMapsToItsToken() {
    let t = Distinct.typography
    let expected: [BraisenlyTextStyle: Font] = [
        .documentTitle: t.documentTitle, .vaultTitle: t.vaultTitle, .bodyReading: t.bodyReading,
        .rowLabel: t.rowLabel, .rowLabelMedium: t.rowLabelMedium, .snippetBody: t.snippetBody,
        .metadata: t.metadata, .badgeNumber: t.badgeNumber, .code: t.code,
        .labelEmphasis: t.labelEmphasis, .chipLabel: t.chipLabel]
    #expect(expected.count == BraisenlyTextStyle.allCases.count)
    #expect(Set(expected.values).count == expected.count, "fixture fonts must be distinct")
    for style in BraisenlyTextStyle.allCases { #expect(style.font(in: t) == expected[style], "\(style)") }
}

@Test func everyToneMapsToItsToken() {
    let c = Distinct.colors
    let expected: [BraisenlyTone: Color] = [
        .primary: c.textPrimary, .bright: c.textBright, .secondary: c.textSecondary, .disabled: c.textDisabled,
        .accent: c.accentTeal, .danger: c.danger, .warning: c.warning, .success: c.success]
    #expect(expected.count == BraisenlyTone.allCases.count)
    #expect(Set(expected.values).count == expected.count, "fixture colors must be distinct")
    for tone in BraisenlyTone.allCases { #expect(tone.color(in: c) == expected[tone], "\(tone)") }
}

@Test func iconSizesMapToTypography() {
    let t = Distinct.typography
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
