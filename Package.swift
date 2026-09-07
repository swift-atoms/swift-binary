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

        .library(name: "Binary Foundation Integration", targets: ["Binary Foundation Integration"]),
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
                .product(name: "Byte", package: "swift-byte"),
            ],
            path: "Sources/Binary"
        ),
        
        .target(
            name: "Binary Foundation Integration",
            dependencies: [
                .target(name: "Binary"),
            ],
            path: "Sources/Binary Foundation Integration"
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
                .target(name: "Binary Test Support"),
                .product(name: "Byte", package: "swift-byte"),
                .target(name: "Binary Foundation Integration"),
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
