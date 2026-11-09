import SwiftUI
@testable import BraisenlySwiftUI

/// Renders a view offscreen under a theme; true when an image was produced.
@MainActor
enum RenderSmoke {
    static func renders<V: View>(
        _ view: V,
        theme: BraisenlyThemeDefinition,
        size: CGSize = CGSize(width: 390, height: 640),
        dynamicType: DynamicTypeSize = .large
    ) -> Bool {
        let content = view
            .braisenlyTheme(theme)
            .dynamicTypeSize(dynamicType)
            .frame(width: size.width, height: size.height)
        return ImageRenderer(content: content).cgImage != nil
    }
}

/// Test-only probe that hands its environment to `read`.
struct EnvironmentReader: View {
    @Environment(\.self) var env
    let read: (EnvironmentValues) -> Void

    var body: some View {
        Color.clear.onAppear { read(env) }
    }
}
