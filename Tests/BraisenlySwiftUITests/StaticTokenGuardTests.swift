import Testing
@testable import BraisenlySwiftUI

@Suite struct StaticTokenGuardTests {
    @Test func noComponentReadsStaticTokensOrLiteralMetrics() throws {
        let violations = try SourceScan.violations(in: SourceScan.allSwiftSources())
        #expect(violations == [])
    }

    @Test func publicAPIIsIdenticalOnIOSAndMacOS() throws {   // U-16
        let violations = try SourceScan.platformConditionalPublicViolations(in: SourceScan.moduleSources("BraisenlySwiftUI"))
        #expect(violations == [])
    }
}
