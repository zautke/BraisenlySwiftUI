import SwiftUI
import Testing
@testable import BraisenlySwiftUI

@MainActor @Suite struct BraisenlyMobileWorkspaceViewTests {
    @Test(arguments: BraisenlyThemes.all)
    func noInitialThemeFollowsEnvironment(environment: BraisenlyThemeDefinition) {
        #expect(BraisenlyMobileWorkspaceView.resolvedTheme(override: nil, environment: environment) == environment)
    }

    @Test func passedInitialThemeWins() {
        let resolved = BraisenlyMobileWorkspaceView.resolvedTheme(
            override: BraisenlyThemes.solarizedDark.id, environment: BraisenlyThemes.solarizedLight)
        #expect(resolved == BraisenlyThemes.solarizedDark)
    }

    @Test func unknownInitialThemeFallsBackToLiquidGlass() {
        let resolved = BraisenlyMobileWorkspaceView.resolvedTheme(override: "nope", environment: BraisenlyThemes.solarizedDark)
        #expect(resolved == BraisenlyThemes.liquidGlass)
    }

    @MainActor @Test(arguments: BraisenlyThemes.all)
    func rendersWithoutInitialTheme(theme: BraisenlyThemeDefinition) {
        #expect(RenderSmoke.renders(BraisenlyMobileWorkspaceView(), theme: theme))
    }
}
