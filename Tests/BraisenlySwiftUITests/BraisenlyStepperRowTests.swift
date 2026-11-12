import SwiftUI
import Testing
@testable import BraisenlySwiftUI

@Suite struct BraisenlyStepperRowTests {
    @Test func stepperRowStoresArguments() {
        let row = BraisenlyStepperRow("Tokens", value: .constant(5), in: 0...150, step: 10)
        #expect(row.title == "Tokens")
        #expect(row.range == 0...150)
        #expect(row.step == 10)
        #expect(BraisenlyStepperRow("X", value: .constant(0), in: 0...1).step == 1)
    }

    @Test func clampedStaysInRange() {
        #expect(BraisenlyStepperRow.clamped(200, to: 0...150) == 150)
        #expect(BraisenlyStepperRow.clamped(-1, to: 0...150) == 0)
        #expect(BraisenlyStepperRow.clamped(70, to: 0...150) == 70)
    }

    @MainActor @Test(arguments: BraisenlyThemes.all)
    func rendersInEveryTheme(theme: BraisenlyThemeDefinition) {
        #expect(RenderSmoke.renders(BraisenlyStepperRow("Tokens", value: .constant(5), in: 0...150), theme: theme))
    }
}
