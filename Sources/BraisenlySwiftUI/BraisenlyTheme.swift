import SwiftUI

public enum BraisenlyTheme: String, CaseIterable, Identifiable, Sendable {
    case light
    case dark

    public var id: Self { self }
    public var colorScheme: ColorScheme { self == .dark ? .dark : .light }
    public var symbolName: String { self == .dark ? "moon.stars.fill" : "sun.max.fill" }
    public var next: Self { self == .dark ? .light : .dark }
}

public extension View {
    func braisenlyTheme(_ theme: BraisenlyTheme) -> some View {
        preferredColorScheme(theme.colorScheme)
    }
}
