// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-binary",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Binary",
            targets: ["Binary"]
        ),
        .library(
            name: "Binary Standard Library Integration",
            targets: ["Binary Standard Library Integration"]
        ),
        .library(
            name: "Binary Apple Foundation Integration",
            targets: ["Binary Apple Foundation Integration"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Binary",
            dependencies: []
        ),
        .target(
            name: "Binary Standard Library Integration",
            dependencies: ["Binary"]
        ),
        .target(
            name: "Binary Apple Foundation Integration",
            dependencies: [
                "Binary",
                "Binary Standard Library Integration",
            ]
        ),
        .testTarget(
            name: "Binary Tests",
            dependencies: ["Binary"]
        ),
        .testTarget(
            name: "Binary Standard Library Integration Tests",
            dependencies: [
                "Binary",
                "Binary Standard Library Integration",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
