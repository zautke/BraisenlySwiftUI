import Foundation

/// Line-based source scan for banned static tokens / literal metrics (spec §11.1)
/// and public declarations inside platform-conditional regions (spec §11.2, U-16).
/// Paths are relative to the package root, e.g. "Sources/BraisenlySwiftUI/BraisenlyModelPill.swift".
enum SourceScan {
    static let bannedPatterns: [(id: String, regex: String)] = [
        ("staticToken", #"BraisenlyDS\.|BraisenlyDesignSystem\."#),
        ("fixedFont", #"\.font\(\.system\(size:\s*[0-9]"#),
        ("literalPadding", #"\.padding\((\.[A-Za-z]+,\s*)?([1-9]|0\.)"#),
        ("ternaryPadding", #"\.padding\([^)]*\?\s*[0-9.]+\s*:\s*[0-9.]+"#),
        ("literalSpacing", #"spacing:\s*[1-9]"#),
        ("literalRadius", #"cornerRadius:\s*[0-9]"#),
        ("colorLiteral", #"Color\.(black|white|gray)|\.black\.opacity"#),
    ]

    static let exemptPrefixes: [String] = [
        "Sources/BraisenlySwiftUI/Theme/",
        "Sources/BraisenlySwiftUI/BraisenlyDesignSystem.swift",
        "Sources/BraisenlySwiftUI/BraisenlyAdaptiveColor.swift",
        "Sources/AI/Models/",
    ]

    static let packageRoot: URL = URL(filePath: #filePath)
        .deletingLastPathComponent() // Support
        .deletingLastPathComponent() // BraisenlySwiftUITests
        .deletingLastPathComponent() // Tests
        .deletingLastPathComponent() // package root

    // MARK: Banned patterns (§11.1)

    static func violations(inSource source: String, named name: String) -> [String] {
        scanLines(source).flatMap { number, line -> [String] in
            bannedPatterns
                .filter { line.range(of: $0.regex, options: .regularExpression) != nil }
                .map { "\(name):\(number): \($0.id)" }
        }
    }

    static func violations(in relativePaths: [String]) throws -> [String] {
        try relativePaths.flatMap { try violations(inSource: read($0), named: $0) }
    }

    /// Every `.swift` under `Sources/`, sorted, minus `exemptPrefixes`.
    static func allSwiftSources() throws -> [String] {
        try swiftFiles(under: "Sources").filter { path in
            !exemptPrefixes.contains { path.hasPrefix($0) }
        }
    }

    // MARK: Platform-conditional public declarations (§11.2, U-16)

    static func platformConditionalPublicViolations(inSource source: String, named name: String) -> [String] {
        let declaration = #"^\s*(@[A-Za-z_]+(\([^)]*\))?\s+)*(nonisolated\s+)?public\s"#
        var frames: [Bool] = [] // true = platform frame
        var result: [String] = []
        for (number, line) in scanLines(source) {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed.hasPrefix("#if ") {
                frames.append(isPlatformCondition(trimmed))
            } else if trimmed.hasPrefix("#elseif "), !frames.isEmpty {
                frames[frames.count - 1] = frames[frames.count - 1] || isPlatformCondition(trimmed)
            } else if trimmed.hasPrefix("#endif") {
                _ = frames.popLast()
            } else if frames.contains(true), line.range(of: declaration, options: .regularExpression) != nil {
                result.append("\(name):\(number): platformConditionalPublic")
            }
        }
        return result
    }

    static func platformConditionalPublicViolations(in relativePaths: [String]) throws -> [String] {
        try relativePaths.flatMap { try platformConditionalPublicViolations(inSource: read($0), named: $0) }
    }

    /// Every `.swift` under `Sources/<module>/`, sorted, no exemptions.
    static func moduleSources(_ module: String) throws -> [String] {
        try swiftFiles(under: "Sources/\(module)")
    }

    // MARK: Helpers

    /// 1-based (line number, line) pairs, skipping `//` comment lines.
    private static func scanLines(_ source: String) -> [(Int, String)] {
        source.split(separator: "\n", omittingEmptySubsequences: false)
            .enumerated()
            .map { ($0.offset + 1, String($0.element)) }
            .filter { !$0.1.trimmingCharacters(in: .whitespaces).hasPrefix("//") }
    }

    private static func isPlatformCondition(_ directive: String) -> Bool {
        directive.contains("os(") || directive.contains("canImport(")
    }

    private static func read(_ relativePath: String) throws -> String {
        try String(contentsOf: packageRoot.appending(path: relativePath), encoding: .utf8)
    }

    private static func swiftFiles(under relativeDirectory: String) throws -> [String] {
        let directory = packageRoot.appending(path: relativeDirectory).path(percentEncoded: false)
        guard let enumerator = FileManager.default.enumerator(atPath: directory) else {
            throw CocoaError(.fileReadNoSuchFile)
        }
        return enumerator
            .compactMap { $0 as? String }
            .filter { $0.hasSuffix(".swift") }
            .map { "\(relativeDirectory)/\($0)" }
            .sorted()
    }
}
