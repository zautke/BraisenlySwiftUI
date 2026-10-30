import SwiftUI

/// Design tokens shared by every Braisenly component.
public enum BraisenlyDesignSystem: Sendable {
    public enum Colors: Sendable {
        public static let backgroundPrimary = Color(red: 0.027, green: 0.129, blue: 0.153)
        public static let backgroundDimmed = Color(red: 0.016, green: 0.082, blue: 0.098)
        public static let surfaceSheet = Color(red: 0.043, green: 0.149, blue: 0.176)
        public static let surfaceElevated = Color(red: 0.094, green: 0.208, blue: 0.235)
        public static let surfaceHighlight = Color(red: 0.157, green: 0.278, blue: 0.310)
        public static let surfaceSnippet = Color(red: 0.047, green: 0.157, blue: 0.184)
        public static let borderSubtle = Color(red: 0.161, green: 0.282, blue: 0.314)
        public static let divider = Color(red: 0.133, green: 0.247, blue: 0.278)
        public static let accentTeal = Color(red: 0.176, green: 0.549, blue: 0.522)
        public static let textPrimary = Color(red: 0.537, green: 0.647, blue: 0.667)
        public static let textBright = Color(red: 0.639, green: 0.741, blue: 0.761)
        public static let textSecondary = Color(red: 0.349, green: 0.467, blue: 0.490)
        public static let textDisabled = Color(red: 0.220, green: 0.333, blue: 0.361)
        public static let matchBackground = Color(red: 0.722, green: 0.353, blue: 0.227)
        public static let matchForeground = Color(red: 0.949, green: 0.898, blue: 0.863)
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
