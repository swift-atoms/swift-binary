# swift-binary

Use this package to turn fixed-width integers into `Byte` sequences and back with an explicit byte order. Optional surfaces add text encodings (Base 16 to 85), LEB128 variable-length integers, a serialization protocol and witness, and bounds-checked read and write positions over a byte span.

## Model

- `Binary.Endianness` is `.little` or `.big`. `.native` is the build target's order, `.network` is `.big`, and `opposite` (or prefix `!`) swaps them.
- Every `FixedWidthInteger` gains `bytes(endianness:)` (returns `[Byte]`, or any `RangeReplaceableCollection` of `Byte`), `bytes(into:endianness:)` (appends to a sink), and the failable `init?(bytes:endianness:)` and `init?(_: Span<Byte>, endianness:)`.
- A `RangeReplaceableCollection` of `Byte` gains `init(_:endianness:)` for one integer, `init(serializing:endianness:)` for a collection of integers, and `append(_:endianness:)`.
- A `RangeReplaceableCollection` of integers gains `init?(bytes:endianness:)`, which splits the bytes into `MemoryLayout<Element>.size` chunks.
- All results are new values; nothing is shared or retained.

## Rules

- `endianness` defaults to `.little` everywhere it has a default.
- An integer always encodes to exactly `MemoryLayout<Self>.size` bytes. Signed values keep their two's-complement bit pattern.
- Decoding one integer returns `nil` unless the byte count equals its size. Decoding a collection returns `nil` unless the byte count is a multiple of the element size.

## Error Handling

The core API never throws; it returns optionals. The optional surfaces throw typed errors:

- `Binary.LEB128.Error`: `.overflow(bitWidth:)` when the value does not fit the target type, `.unterminated` when the input ends before a byte with a clear continuation bit.
- `Binary.Cursor.Error`: `.invariant(reader:writer:)` when the reader would pass the writer, `.bounds(_:value:lower:upper:)` when a position leaves the valid range, `.overflow(_:)` when index arithmetic overflows. The `Binary.Cursor.Error.Field` argument is `.reader` or `.writer`.
- `Binary.Reader.Error`: `.bounds(value:lower:upper:)` and `.overflow`.

All three are `Sendable` and `Equatable`. A cursor or reader method that throws leaves the indices unchanged; a LEB128 parser that throws has already consumed the bytes it read.

## Example

```swift
import Binary

let bytes = [Byte](serializing: [UInt16(1), 2, 3], endianness: .big)
// 00 01 00 02 00 03
let values = [UInt16](bytes: bytes, endianness: .big)       // [1, 2, 3]

var buffer = ContiguousArray<Byte>()
buffer.append(UInt16(0x1234), endianness: .little)           // 34 12
let word = UInt16(bytes: buffer, endianness: .little)        // 0x1234
```

## Base encodings

This trait adds ``Binary.Base.`16` ``, `` `32` ``, `` `58` ``, `` `62` ``, `` `64` `` and `` `85` ``, each with static `encode` and `decode` callables.

- Base 16, 32 and 64 encode `[Byte]` to `String` with a caller-supplied alphabet; decode returns `[Byte]?`. Base 32 and 64 take an optional `pad` byte: encode appends it, decode strips trailing pad bytes.
- Base 58, 62 and 85 encode a `UInt64` as a positional number (zero is the alphabet's first byte); decode returns `UInt64?` and is `nil` on overflow.
- Base 62 has built-in alphabets: ``Binary.Base.`62`.Alphabet`` with `.standard` (the default: digits, then uppercase, then lowercase), `.gmp` and `.inverted`, plus `digit(_:)` and `isValid(_:)` per byte.
- Decode returns `nil` for any byte outside the alphabet; Base 16 decode also returns `nil` for odd-length input. An alphabet of the wrong length, or a Base 62 alphabet with a repeated byte, is a precondition failure.

## UInt8 interop

The `Byte` trait adds disfavoured `[UInt8]` overloads: `bytes(endianness:)` returning `[UInt8]`, `init?(bytes: [UInt8], endianness:)`, `[T](bytes:endianness:)` from a `UInt8` collection, and `[UInt8].append(_:endianness:)` for each standard integer width (`Int` and `UInt` require an explicit endianness). It also adds `append(utf8:)` on byte collections.

## LEB128

This trait adds `[Byte](leb128:)` for signed and unsigned integers, and the parsers `Binary.LEB128.Unsigned<T>` and `Binary.LEB128.Signed<T>`, whose `parse(_:)` consumes only the bytes of one value from an `ArraySlice<Byte>`. Decoding is strict: an encoding longer than the target width allows throws `.overflow`, even when the extra bytes are zero. `Binary.LEB128.Decode.unsigned` and `.signed` decode one byte at a time for callers that drive their own loop.

## Serialization

This trait adds two ways to write a value:

- `Binary.Serializable`, a protocol with one requirement, `static func serialize(_:into:)`. Conformers get `bytes`, `serialize(into:)`, `withSerializedBytes(_:)` (a borrowed `Span<Byte>`), `String(_:)`, and `append(_:)` and `init(_:)` on byte collections. `[Byte]`, `ContiguousArray<Byte>`, `ArraySlice<Byte>` and `Tagged` over a serializable value conform. `RawRepresentable` conformers with a string, `[Byte]`, `[UInt8]` or integer raw value get a default; the integer default uses the native byte order.
- `Binary.Serializer<Value>`, a witness wrapping a closure that appends to `[Byte]`, with `serializeToArray(_:)` and `serializeAppending(_:to:)`. `Int8` through `UInt64` each have `serializer(endianness:)`, and `.rawValue` (or `.rawValue(endianness:)` for integer raw values) serializes raw-representable values. Pick the witness when the byte order must be explicit or a type needs more than one encoding.

## Cursor

This trait adds two noncopyable, nonescapable position trackers over storage that exposes a `Span` of `Byte`. Neither writes to the storage.

- `Binary.Reader` has one `readerIndex` (an `Ordinal`) with `0 <= readerIndex <= count`, plus `remainingCount`, `hasRemaining`, `isAtEnd` and `remainingBytes`.
- `Binary.Cursor` has a `readerIndex` and a `writerIndex` with `0 <= readerIndex <= writerIndex <= count`; `readableBytes` is the span between them. Both indices start at zero, so nothing is readable until the writer moves.
- `moveReaderIndex(by:)`, `moveWriterIndex(by:)` (taking a `Difference`), `setReaderIndex(to:)` and `setWriterIndex(to:)` throw on any violation. Each has an `__unchecked:` variant that traps instead; the unchecked moves wrap the offset arithmetic. `reset()` returns the indices to zero.
