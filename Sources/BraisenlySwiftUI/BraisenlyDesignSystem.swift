import SwiftUI

/// Static Solarized source values; components read `EnvironmentValues.braisenlyTheme`.
public enum BraisenlyDesignSystem: Sendable {
    /// Canonical Solarized sRGB palette by Ethan Schoonover.
    public enum Solarized: Sendable {
        public static let base03 = color(0x002B36)
        public static let base02 = color(0x073642)
        public static let base01 = color(0x586E75)
        public static let base00 = color(0x657B83)
        public static let base0 = color(0x839496)
        public static let base1 = color(0x93A1A1)
        public static let base2 = color(0xEEE8D5)
        public static let base3 = color(0xFDF6E3)
        public static let yellow = color(0xB58900)
        public static let orange = color(0xCB4B16)
        public static let red = color(0xDC322F)
        public static let magenta = color(0xD33682)
        public static let violet = color(0x6C71C4)
        public static let blue = color(0x268BD2)
        public static let cyan = color(0x2AA198)
        public static let green = color(0x859900)

        private static func color(_ hex: UInt32) -> Color {
            let value = BraisenlyRGB(hex)
            return Color(red: value.red, green: value.green, blue: value.blue)
        }
    }

    public enum Colors: Sendable {
        public static let backgroundPrimary = adaptive(light: 0xFDF6E3, dark: 0x002B36)
        public static let backgroundDimmed = adaptive(light: 0xEEE8D5, dark: 0x002B36)
        public static let surfaceSheet = adaptive(light: 0xEEE8D5, dark: 0x073642)
        public static let surfaceElevated = adaptive(light: 0xEEE8D5, dark: 0x073642)
        public static let surfaceHighlight = adaptive(light: 0x93A1A1, dark: 0x586E75)
        public static let surfaceSnippet = adaptive(light: 0xEEE8D5, dark: 0x073642)
        public static let borderSubtle = adaptive(light: 0x93A1A1, dark: 0x586E75)
        public static let divider = adaptive(light: 0x93A1A1, dark: 0x586E75)
        public static let accentTeal = Solarized.cyan
        public static let textPrimary = adaptive(light: 0x657B83, dark: 0x839496)
        public static let textBright = adaptive(light: 0x586E75, dark: 0x93A1A1)
        public static let textSecondary = adaptive(light: 0x657B83, dark: 0x586E75)
        public static let textDisabled = adaptive(light: 0x93A1A1, dark: 0x586E75)
        public static let matchBackground = Solarized.orange
        public static let matchForeground = Solarized.base3

        private static func adaptive(light: UInt32, dark: UInt32) -> Color {
            BraisenlyAdaptiveColor.make(light: BraisenlyRGB(light), dark: BraisenlyRGB(dark))
        }
    }

    public enum Typography: Sendable {
        public static let documentTitle = Font.system(size: 30, weight: .bold)
        public static let bodyReading = Font.system(size: 17.5)
        public static let vaultTitle = Font.system(size: 20, weight: .bold)
        public static let rowLabel = Font.system(size: 16.5)
        public static let rowLabelMedium = Font.system(size: 16.5, weight: .medium)
        public static let snippetBody = Font.system(size: 14)
        public static let metadata = Font.system(size: 13.5)
        public static let badgeNumber = Font.system(size: 12, weight: .bold, design: .rounded)
    }

    public enum Metrics: Sendable {
        public static let circleButtonSize: CGFloat = 44
        public static let toolbarHeight: CGFloat = 54
        public static let rowHeight: CGFloat = 48
        public static let cardRadius: CGFloat = 20
        public static let popoverRadius: CGFloat = 24
        public static let snippetRadius: CGFloat = 10
        public static let sidebarWidthRatio: CGFloat = 0.84
    }
}

/// Short namespace alias for token-heavy component implementations.
public typealias BraisenlyDS = BraisenlyDesignSystem
