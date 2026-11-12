import SwiftUI

/// A step on a ``BraisenlyScale``. `.zero` always resolves to 0.
public enum BraisenlyStep: String, CaseIterable, Sendable { case zero, xs, s, m, l, xl }

/// A five-step size scale (spacing or corner radius).
public struct BraisenlyScale: Sendable, Equatable {
    public var xs: CGFloat, s: CGFloat, m: CGFloat, l: CGFloat, xl: CGFloat

    public init(xs: CGFloat, s: CGFloat, m: CGFloat, l: CGFloat, xl: CGFloat) {
        self.xs = xs
        self.s = s
        self.m = m
        self.l = l
        self.xl = xl
    }

    public subscript(_ step: BraisenlyStep) -> CGFloat {
        switch step {
        case .zero: 0
        case .xs: xs
        case .s: s
        case .m: m
        case .l: l
        case .xl: xl
        }
    }
}

/// Color tokens of a theme. Names match `BraisenlyDS.Colors` so migration is a mechanical rename.
public struct BraisenlyColorTokens: Sendable, Equatable {
    public var backgroundPrimary, backgroundDimmed, surfaceSheet, surfaceElevated,
               surfaceHighlight, surfaceSnippet, borderSubtle, divider, accentTeal,
               textPrimary, textBright, textSecondary, textDisabled,
               matchBackground, matchForeground: Color
    public var danger, warning, success, scrim, shadow: Color

    public init(
        backgroundPrimary: Color,
        backgroundDimmed: Color,
        surfaceSheet: Color,
        surfaceElevated: Color,
        surfaceHighlight: Color,
        surfaceSnippet: Color,
        borderSubtle: Color,
        divider: Color,
        accentTeal: Color,
        textPrimary: Color,
        textBright: Color,
        textSecondary: Color,
        textDisabled: Color,
        matchBackground: Color,
        matchForeground: Color,
        danger: Color,
        warning: Color,
        success: Color,
        scrim: Color,
        shadow: Color
    ) {
        self.backgroundPrimary = backgroundPrimary
        self.backgroundDimmed = backgroundDimmed
        self.surfaceSheet = surfaceSheet
        self.surfaceElevated = surfaceElevated
        self.surfaceHighlight = surfaceHighlight
        self.surfaceSnippet = surfaceSnippet
        self.borderSubtle = borderSubtle
        self.divider = divider
        self.accentTeal = accentTeal
        self.textPrimary = textPrimary
        self.textBright = textBright
        self.textSecondary = textSecondary
        self.textDisabled = textDisabled
        self.matchBackground = matchBackground
        self.matchForeground = matchForeground
        self.danger = danger
        self.warning = warning
        self.success = success
        self.scrim = scrim
        self.shadow = shadow
    }

    /// Fixed (non-adaptive) Solarized palette for one scheme; the Solarized themes pin their scheme.
    public static func solarized(_ scheme: ColorScheme) -> Self {
        typealias S = BraisenlyDS.Solarized
        let dark = scheme == .dark
        return Self(
            backgroundPrimary: dark ? S.base03 : S.base3,
            backgroundDimmed: dark ? S.base03 : S.base2,
            surfaceSheet: dark ? S.base02 : S.base2,
            surfaceElevated: dark ? S.base02 : S.base2,
            surfaceHighlight: dark ? S.base01 : S.base1,
            surfaceSnippet: dark ? S.base02 : S.base2,
            borderSubtle: dark ? S.base01 : S.base1,
            divider: dark ? S.base01 : S.base1,
            accentTeal: S.cyan,
            textPrimary: dark ? S.base0 : S.base00,
            textBright: dark ? S.base1 : S.base01,
            textSecondary: dark ? S.base01 : S.base00,
            textDisabled: dark ? S.base01 : S.base1,
            matchBackground: S.orange,
            matchForeground: S.base3,
            danger: S.red,
            warning: S.orange,
            success: S.green,
            scrim: Color.black.opacity(0.38),
            shadow: Color.black.opacity(0.35)
        )
    }

    /// Liquid Glass palette: platform semantic colors for surfaces and text,
    /// Solarized brand values for accent, match, status, scrim and shadow.
    public static var system: Self {
        var tokens = solarized(.light)
        tokens.backgroundPrimary = BraisenlySystemColor.backgroundPrimary
        tokens.backgroundDimmed = BraisenlySystemColor.backgroundDimmed
        tokens.surfaceSheet = BraisenlySystemColor.surfaceSheet
        tokens.surfaceElevated = BraisenlySystemColor.surfaceElevated
        tokens.surfaceHighlight = BraisenlySystemColor.surfaceHighlight
        tokens.surfaceSnippet = BraisenlySystemColor.surfaceSnippet
        tokens.borderSubtle = BraisenlySystemColor.separator
        tokens.divider = BraisenlySystemColor.separator
        tokens.textPrimary = BraisenlySystemColor.label
        tokens.textBright = BraisenlySystemColor.label
        tokens.textSecondary = BraisenlySystemColor.secondaryLabel
        tokens.textDisabled = BraisenlySystemColor.tertiaryLabel
        return tokens
    }
}

/// Typography tokens. Every value is text-style based, so it scales with Dynamic Type.
public struct BraisenlyTypographyTokens: Sendable, Equatable {
    public var documentTitle, vaultTitle, bodyReading, rowLabel, rowLabelMedium,
               snippetBody, metadata, badgeNumber, code, labelEmphasis, chipLabel,
               rowIcon, controlIcon, controlIconEmphasis: Font

    public init(
        documentTitle: Font,
        vaultTitle: Font,
        bodyReading: Font,
        rowLabel: Font,
        rowLabelMedium: Font,
        snippetBody: Font,
        metadata: Font,
        badgeNumber: Font,
        code: Font,
        labelEmphasis: Font,
        chipLabel: Font,
        rowIcon: Font,
        controlIcon: Font,
        controlIconEmphasis: Font
    ) {
        self.documentTitle = documentTitle
        self.vaultTitle = vaultTitle
        self.bodyReading = bodyReading
        self.rowLabel = rowLabel
        self.rowLabelMedium = rowLabelMedium
        self.snippetBody = snippetBody
        self.metadata = metadata
        self.badgeNumber = badgeNumber
        self.code = code
        self.labelEmphasis = labelEmphasis
        self.chipLabel = chipLabel
        self.rowIcon = rowIcon
        self.controlIcon = controlIcon
        self.controlIconEmphasis = controlIconEmphasis
    }

    public static let standard = Self(
        documentTitle: .system(.title, weight: .bold),
        vaultTitle: .system(.title3, weight: .bold),
        bodyReading: .system(.body),
        rowLabel: .system(.body),
        rowLabelMedium: .system(.body, weight: .medium),
        snippetBody: .system(.subheadline),
        metadata: .system(.footnote),
        badgeNumber: .system(.caption, design: .rounded, weight: .bold),
        code: .system(.footnote, design: .monospaced),
        labelEmphasis: .system(.footnote, weight: .semibold),
        chipLabel: .system(.caption2, weight: .semibold),
        rowIcon: .system(.subheadline, weight: .medium),
        controlIcon: .system(.title3, weight: .medium),
        controlIconEmphasis: .system(.callout, weight: .bold)
    )
}

/// Layout metric tokens.
public struct BraisenlyMetricTokens: Sendable, Equatable {
    public var spacing: BraisenlyScale
    public var radius: BraisenlyScale
    public var circleButtonSize: CGFloat
    public var toolbarHeight: CGFloat
    public var rowHeight: CGFloat
    public var sidebarWidthRatio: CGFloat
    public var hairline: CGFloat
    public var sheetCornerRadius: CGFloat
    public var grabberSize: CGSize

    public init(
        spacing: BraisenlyScale,
        radius: BraisenlyScale,
        circleButtonSize: CGFloat,
        toolbarHeight: CGFloat,
        rowHeight: CGFloat,
        sidebarWidthRatio: CGFloat,
        hairline: CGFloat,
        sheetCornerRadius: CGFloat,
        grabberSize: CGSize
    ) {
        self.spacing = spacing
        self.radius = radius
        self.circleButtonSize = circleButtonSize
        self.toolbarHeight = toolbarHeight
        self.rowHeight = rowHeight
        self.sidebarWidthRatio = sidebarWidthRatio
        self.hairline = hairline
        self.sheetCornerRadius = sheetCornerRadius
        self.grabberSize = grabberSize
    }

    public static let standard = Self(
        spacing: BraisenlyScale(xs: 4, s: 8, m: 12, l: 16, xl: 24),
        radius: BraisenlyScale(xs: 4, s: 10, m: 14, l: 20, xl: 24),
        circleButtonSize: 44,
        toolbarHeight: 54,
        rowHeight: 48,
        sidebarWidthRatio: 0.84,
        hairline: 0.5,
        sheetCornerRadius: 28,
        grabberSize: CGSize(width: 46, height: 5)
    )
}
