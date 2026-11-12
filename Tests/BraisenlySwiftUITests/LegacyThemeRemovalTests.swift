import Foundation
import Testing
@testable import BraisenlySwiftUI

@Suite struct LegacyThemeRemovalTests {
    @Test func legacyThemeTypesAreGone() throws {
        let hits = try SourceScan.allSwiftSources().filter { path in
            let text = try! String(contentsOf: SourceScan.packageRoot.appending(path: path), encoding: .utf8)
            return text.contains("BraisenlyTheme.") || text.contains("enum BraisenlyTheme:") || text.contains("BraisenlyThemeToggle")
        }
        #expect(hits == [])
    }
}
