// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-binary-primitives",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [

        .library(
            name: "Binary Primitive",
            targets: ["Binary Primitive"]
        ),

        .library(
            name: "Binary Endianness Primitives",
            targets: ["Binary Endianness Primitives"]
        ),

        .library(
            name: "Binary Primitives Standard Library Integration",
            targets: ["Binary Primitives Standard Library Integration"]
        ),

        .library(
            name: "Binary Primitives",
            targets: ["Binary Primitives"]
        ),

        .library(
            name: "Binary Primitives Test Support",
            targets: ["Binary Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-primitives/swift-byte-primitives.git",
            branch: "main"
        )
    ],
    targets: [

        .target(
            name: "Binary Primitive",
            dependencies: []
        ),

        .target(
            name: "Binary Endianness Primitives",
            dependencies: [
                "Binary Primitive"
            ]
        ),

        .target(
            name: "Binary Primitives Standard Library Integration",
            dependencies: [
                "Binary Primitive",
                "Binary Endianness Primitives",
                .product(name: "Byte Primitives", package: "swift-byte-primitives"),
                .product(
                    name: "Byte Primitives Standard Library Integration",
                    package: "swift-byte-primitives"
                ),
            ]
        ),

        .target(
            name: "Binary Primitives",
            dependencies: [
                "Binary Primitive",
                "Binary Endianness Primitives",
                "Binary Primitives Standard Library Integration",
            ]
        ),

        .target(
            name: "Binary Primitives Test Support",
            dependencies: [
                "Binary Primitives"
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Binary Primitives Tests",
            dependencies: [
                "Binary Primitives",
                "Binary Primitives Standard Library Integration",
                "Binary Primitives Test Support",
            ]
        ),
        .testTarget(
            name: "Binary Primitives Standard Library Integration Tests",
            dependencies: [
                "Binary Primitives",
                "Binary Primitives Standard Library Integration",
                "Binary Primitives Test Support",
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
