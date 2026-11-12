import SwiftUI

/// Named text roles mapped to `BraisenlyTypographyTokens`.
public enum BraisenlyTextStyle: String, CaseIterable, Sendable {
    case documentTitle, vaultTitle, bodyReading, rowLabel, rowLabelMedium, snippetBody,
         metadata, badgeNumber, code, labelEmphasis, chipLabel

    public func font(in typography: BraisenlyTypographyTokens) -> Font {
        switch self {
        case .documentTitle: typography.documentTitle
        case .vaultTitle: typography.vaultTitle
        case .bodyReading: typography.bodyReading
        case .rowLabel: typography.rowLabel
        case .rowLabelMedium: typography.rowLabelMedium
        case .snippetBody: typography.snippetBody
        case .metadata: typography.metadata
        case .badgeNumber: typography.badgeNumber
        case .code: typography.code
        case .labelEmphasis: typography.labelEmphasis
        case .chipLabel: typography.chipLabel
        }
    }
}

/// Semantic foreground roles mapped to `BraisenlyColorTokens`.
public enum BraisenlyTone: String, CaseIterable, Sendable {
    case primary, bright, secondary, disabled, accent, danger, warning, success

    public func color(in colors: BraisenlyColorTokens) -> Color {
        switch self {
        case .primary: colors.textPrimary
        case .bright: colors.textBright
        case .secondary: colors.textSecondary
        case .disabled: colors.textDisabled
        case .accent: colors.accentTeal
        case .danger: colors.danger
        case .warning: colors.warning
        case .success: colors.success
        }
    }
}

/// Icon sizes mapped to typography tokens (chipLabel / rowIcon / controlIcon).
public enum BraisenlyIconSize: String, CaseIterable, Sendable {
    case small, medium, large

    public func font(in typography: BraisenlyTypographyTokens) -> Font {
        switch self {
        case .small: typography.chipLabel
        case .medium: typography.rowIcon
        case .large: typography.controlIcon
        }
    }
}
