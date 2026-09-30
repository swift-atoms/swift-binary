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
        .library(name: "Binary Base Test Support", targets: ["Binary Base Test Support"]),
        .library(name: "Binary LEB128 Parser Test Support", targets: ["Binary LEB128 Parser Test Support"]),
        .library(name: "Binary LEB128 Test Support", targets: ["Binary LEB128 Test Support"]),
        .library(name: "Binary Serializer Test Support", targets: ["Binary Serializer Test Support"]),

        .library(name: "Binary Cursor Test Support", targets: ["Binary Cursor Test Support"]),
    ],
    traits: [
        .trait(name: "Base", description: "Absorbed Base integration"),
        .trait(name: "Byte", description: "Absorbed Byte integration"),
        .trait(name: "LEB128", description: "Absorbed LEB128 integration"),
        .trait(name: "Serializer", description: "Absorbed Serializer integration"),

        .trait(name: "Cursor", description: "Checked binary positions and explicitly wrapping unchecked movement"),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-byte.git",
            branch: "main"
        ),
        .package(url: "https://github.com/swift-atoms/swift-parser.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-property.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-serializer.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-tagged.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-witness.git", branch: "main"),

        .package(url: "https://github.com/swift-atoms/swift-cardinal.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-difference.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-ordinal.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-index.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-span.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Binary",
            dependencies: [
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "Parser", package: "swift-parser"),
                .product(name: "Property", package: "swift-property"),
                .product(name: "Serializer", package: "swift-serializer"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Witness", package: "swift-witness"),

                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Difference", package: "swift-difference"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Span", package: "swift-span"),
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
        .testTarget(name: "Absorbed swift-binary-base Binary Base Tests", dependencies: [.target(name: "Binary"), .target(name: "Binary Base Test Support"), .product(name: "Byte", package: "swift-byte")], path: "Tests/Absorbed/swift-binary-base/Binary Base Tests"),
        .target(name: "Binary Base Test Support", dependencies: [.target(name: "Binary")], path: "Tests/Absorbed/swift-binary-base/Support"),
        .testTarget(name: "Absorbed swift-binary-byte Binary Byte Tests", dependencies: [.target(name: "Binary"), .product(name: "Byte", package: "swift-byte")], path: "Tests/Absorbed/swift-binary-byte/Binary Byte Tests"),
        .testTarget(name: "Absorbed swift-binary-leb128 Binary LEB128 Parser Tests", dependencies: [.target(name: "Binary"), .target(name: "Binary LEB128 Parser Test Support"), .product(name: "Byte", package: "swift-byte")], path: "Tests/Absorbed/swift-binary-leb128/Binary LEB128 Parser Tests"),
        .testTarget(name: "Absorbed swift-binary-leb128 Binary LEB128 Tests", dependencies: [.target(name: "Binary"), .target(name: "Binary LEB128 Test Support"), .product(name: "Byte", package: "swift-byte")], path: "Tests/Absorbed/swift-binary-leb128/Binary LEB128 Tests"),
        .target(name: "Binary LEB128 Parser Test Support", dependencies: [.target(name: "Binary")], path: "Tests/Absorbed/swift-binary-leb128/Parser Support"),
        .target(name: "Binary LEB128 Test Support", dependencies: [.target(name: "Binary")], path: "Tests/Absorbed/swift-binary-leb128/Support"),
        .testTarget(name: "Absorbed swift-binary-serializer Binary Serializer Tests", dependencies: [.target(name: "Binary"), .target(name: "Binary Serializer Test Support"), .product(name: "Byte", package: "swift-byte")], path: "Tests/Absorbed/swift-binary-serializer/Binary Serializer Tests"),
        .target(name: "Binary Serializer Test Support", dependencies: [.target(name: "Binary")], path: "Tests/Absorbed/swift-binary-serializer/Support"),

        .target(
            name: "Binary Cursor Test Support",
            dependencies: [
                .target(name: "Binary", condition: .when(traits: ["Cursor"])),
                .target(name: "Binary Test Support", condition: .when(traits: ["Cursor"])),
            ],
            path: "Tests/Decision Binary Cursor/Support"
        ),
        .testTarget(
            name: "Decision Binary Cursor Tests",
            dependencies: [
                .target(name: "Binary", condition: .when(traits: ["Cursor"])),
                .target(name: "Binary Cursor Test Support", condition: .when(traits: ["Cursor"])),
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "Difference", package: "swift-difference"),
                .product(name: "Span", package: "swift-span"),
            ],
            path: "Tests/Decision Binary Cursor/Binary Cursor Tests"
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
