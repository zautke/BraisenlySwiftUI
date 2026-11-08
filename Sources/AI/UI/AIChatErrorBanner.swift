import BraisenlySwiftUI
import SwiftUI

public struct AIChatErrorBanner: View {
    public let failure: AIChatFailure
    public let onDismiss: () -> Void

    public init(failure: AIChatFailure, onDismiss: @escaping () -> Void) {
        self.failure = failure
        self.onDismiss = onDismiss
    }

    public var body: some View {
        BraisenlyBannerCard(
            message: failure.message,
            systemImage: "exclamationmark.triangle.fill",
            iconColor: BraisenlyDS.Solarized.red,
            onDismiss: onDismiss
        )
    }
}
