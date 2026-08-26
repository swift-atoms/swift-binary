# Binary

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Byte-order policy and a fixed-width-integer ↔ byte codec for Swift — explicit big/little-endian serialization with zero platform dependencies.

---

## Quick Start

`Binary` is a dependency-free namespace for the binary-domain vocabulary: the byte-order policy `Binary.Endianness` and the fixed-width-integer ↔ byte codec. The standard library only offers `.bigEndian` / `.littleEndian` bit-swaps on the integer itself; this package gives you the byte array in the order you choose, plus the inverse decode that validates length.

```swift
import Binary

// Serialize an integer to bytes in an explicit byte order.
let value: UInt32 = 0x1234_5678

let network = value.bytes(endianness: .big)       // [0x12, 0x34, 0x56, 0x78]
let native  = value.bytes(endianness: .little)    // [0x78, 0x56, 0x34, 0x12]

// Decode back. Returns nil when the byte count doesn't match the type's size.
let recovered = UInt32(bytes: network, endianness: .big)   // 0x1234_5678
let truncated = UInt32(bytes: [0x12, 0x34], endianness: .big)   // nil

// Byte order is a value: query the platform's, flip it, or take network order.
let order = Binary.Endianness.native    // .little on x86 / ARM
let flipped = !order                    // .big
let wire = Binary.Endianness.network    // always .big
```

The codec is zero-copy on the decode side — `init(_:Span<Byte>)` reads straight from a borrowed contiguous view — and allocation-free on the encode side via `bytes(into:)`, which appends into a caller-owned sink you can reuse across calls.

---

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-molecules/swift-binary.git", branch: "main")
]
```

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Binary", package: "swift-binary"),
    ]
)
```

Requires Swift 6.3.1 and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26 (or the matching Linux / Windows toolchain).

---

## Architecture

Five library products over a single dependency (`swift-byte`). Import the umbrella for the full surface, or a single variant to minimize it.

| Product | Target | When to import |
|---------|--------|----------------|
| `Binary` | `Sources/Binary/` | The umbrella — re-exports Endianness + the codec. Import this for the full surface. |
| `Binary Primitive` | `Sources/Binary Primitive/` | The dependency-free `enum Binary {}` namespace only, with no codec or endianness. |
| `Binary Endianness` | `Sources/Binary Endianness/` | The `Binary.Endianness` byte-order policy in isolation. |
| `Binary Standard Library Integration` | `Sources/Binary Standard Library Integration/` | The `FixedWidthInteger` / `Array` / `RangeReplaceableCollection` byte codec extensions over `Byte` and `UInt8`. |
| `Binary Test Support` | `Tests/Support/` | Re-exports the umbrella for test consumers. |

Foundation-free.

---

## Platform Support

| Platform | Status |
|----------|--------|
| macOS 26 | Full support |
| Linux | Full support |
| Windows | Full support |
| iOS / tvOS / watchOS / visionOS | Supported |
| Swift Embedded | Supported |

---

## Community

<!-- BEGIN: discussion -->
<!-- Discussion thread created at publication. -->
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
