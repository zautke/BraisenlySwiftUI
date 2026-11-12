import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// Platform semantic colors behind the Liquid Glass palette (`BraisenlyColorTokens.system`).
enum BraisenlySystemColor {
#if canImport(UIKit)
    static let backgroundPrimary = Color(uiColor: .systemBackground)
    static let backgroundDimmed = Color(uiColor: .secondarySystemBackground)
    static let surfaceSheet = Color(uiColor: .secondarySystemBackground)
    static let surfaceElevated = Color(uiColor: .secondarySystemBackground)
    static let surfaceHighlight = Color(uiColor: .tertiarySystemFill)
    static let surfaceSnippet = Color(uiColor: .tertiarySystemBackground)
    static let separator = Color(uiColor: .separator)
    static let label = Color(uiColor: .label)
    static let secondaryLabel = Color(uiColor: .secondaryLabel)
    static let tertiaryLabel = Color(uiColor: .tertiaryLabel)
#elseif canImport(AppKit)
    static let backgroundPrimary = Color(nsColor: .windowBackgroundColor)
    static let backgroundDimmed = Color(nsColor: .underPageBackgroundColor)
    static let surfaceSheet = Color(nsColor: .windowBackgroundColor)
    static let surfaceElevated = Color(nsColor: .controlBackgroundColor)
    static let surfaceHighlight = Color(nsColor: .unemphasizedSelectedContentBackgroundColor)
    static let surfaceSnippet = Color(nsColor: .controlBackgroundColor)
    static let separator = Color(nsColor: .separatorColor)
    static let label = Color(nsColor: .labelColor)
    static let secondaryLabel = Color(nsColor: .secondaryLabelColor)
    static let tertiaryLabel = Color(nsColor: .tertiaryLabelColor)
#endif
}
