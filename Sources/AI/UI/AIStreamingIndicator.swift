import BraisenlySwiftUI
import SwiftUI

public struct AIStreamingIndicator: View {
    public let label: String

    public init(label: String = "Thinking…") {
        self.label = label
    }

    public var body: some View {
        BraisenlyPulseIndicator(label: label)
    }
}
