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
        .library(name: "Binary", targets: ["Binary"]),
        .library(name: "Binary Standard Library Integration", targets: ["Binary Standard Library Integration"]),
        .library(name: "Binary Foundation Library Integration", targets: ["Binary Foundation Library Integration"]),
        .library(name: "Binary Test Support", targets: ["Binary Test Support"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-byte.git",
            branch: "main"
        )
    ],
    targets: [
        .target(
            name: "Binary",
            dependencies: [
            ],
            path: "Sources/Binary"
        ),
        .target(
            name: "Binary Standard Library Integration",
            dependencies: [
                .target(name: "Binary"),
                .product(name: "Byte", package: "swift-byte"),
            ],
            path: "Sources/Binary Standard Library Integration"
        ),
        .target(
            name: "Binary Foundation Library Integration",
            dependencies: [
                .target(name: "Binary"),
                .target(name: "Binary Standard Library Integration"),
            ],
            path: "Sources/Binary Foundation Library Integration"
        ),
        .target(
            name: "Binary Test Support",
            dependencies: [
                .target(name: "Binary"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Binary Tests",
            dependencies: [
                .target(name: "Binary"),
                .target(name: "Binary Standard Library Integration"),
                .target(name: "Binary Test Support"),
                .product(name: "Byte", package: "swift-byte"),
                .target(name: "Binary Foundation Library Integration"),
            ],
            path: "Tests/Binary Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
