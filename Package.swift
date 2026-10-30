// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BraisenlySwiftUI",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "BraisenlySwiftUI",
            targets: ["BraisenlySwiftUI"]
        ),
        .library(
            name: "BraisenlyAI",
            targets: ["BraisenlyAI"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "BraisenlySwiftUI",
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
        .target(
            name: "BraisenlyAI",
            dependencies: ["BraisenlySwiftUI"],
            path: "Sources/AI",
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ]
        ),
        .testTarget(
            name: "BraisenlySwiftUITests",
            dependencies: ["BraisenlySwiftUI"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
        .testTarget(
            name: "BraisenlyAITests",
            dependencies: ["BraisenlyAI"],
            path: "Tests/BraisenlyAITests",
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ]
        ),
    ]
)
