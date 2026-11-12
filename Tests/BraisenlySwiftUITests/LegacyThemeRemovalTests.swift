import Foundation
import Testing
@testable import BraisenlySwiftUI

@Suite struct LegacyThemeRemovalTests {
    @Test func legacyThemeTypesAreGone() throws {
        let sources = try SourceScan.moduleSources("BraisenlySwiftUI") + SourceScan.moduleSources("AI")
        let hits = try sources.filter { path in
            let text = try String(contentsOf: SourceScan.packageRoot.appending(path: path), encoding: .utf8)
            return text.contains("BraisenlyTheme.") || text.contains("enum BraisenlyTheme:") || text.contains("BraisenlyThemeToggle")
        }
        #expect(hits == [])
        for file in ["Sources/BraisenlySwiftUI/BraisenlyTheme.swift", "Sources/BraisenlySwiftUI/BraisenlyThemeToggle.swift"] {
            #expect(!FileManager.default.fileExists(atPath: SourceScan.packageRoot.appending(path: file).path(percentEncoded: false)), "\(file) still exists")
        }
    }
}
