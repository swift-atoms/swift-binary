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
            name: "Binary Endianness",
            targets: ["Binary Endianness"]
        ),

        .library(
            name: "Binary Standard Library Integration",
            targets: ["Binary Standard Library Integration"]
        ),

        .library(
            name: "Binary",
            targets: ["Binary"]
        ),

        .library(
            name: "Binary Test Support",
            targets: ["Binary Test Support"]
        ),
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
            dependencies: []
        ),

        .target(
            name: "Binary Endianness",
            dependencies: [
                .target(name: "Binary")
            ]
        ),

        .target(
            name: "Binary Standard Library Integration",
            dependencies: [
                .target(name: "Binary"),
                .target(name: "Binary Endianness"),
                .product(name: "Byte", package: "swift-byte"),
            ]
        ),

        .target(
            name: "Binary Test Support",
            dependencies: [
                .target(name: "Binary")
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Binary Tests",
            dependencies: [
                .target(name: "Binary"),
                .target(name: "Binary Endianness"),
                .target(name: "Binary Standard Library Integration"),
                .target(name: "Binary Test Support"),
                .product(name: "Byte", package: "swift-byte"),
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
