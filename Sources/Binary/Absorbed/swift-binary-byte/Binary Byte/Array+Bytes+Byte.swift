#if Byte
internal import Byte

extension [UInt8] {

    @inlinable
    public mutating func append(_ value: UInt16, endianness: Binary.Endianness = .little) {
        append(contentsOf: [Byte](value, endianness: endianness).map(\.bitPattern))
    }

    @inlinable
    public mutating func append(_ value: UInt32, endianness: Binary.Endianness = .little) {
        append(contentsOf: [Byte](value, endianness: endianness).map(\.bitPattern))
    }

    @inlinable
    public mutating func append(_ value: UInt64, endianness: Binary.Endianness = .little) {
        append(contentsOf: [Byte](value, endianness: endianness).map(\.bitPattern))
    }

    @inlinable
    public mutating func append(_ value: Int16, endianness: Binary.Endianness = .little) {
        append(contentsOf: [Byte](value, endianness: endianness).map(\.bitPattern))
    }

    @inlinable
    public mutating func append(_ value: Int32, endianness: Binary.Endianness = .little) {
        append(contentsOf: [Byte](value, endianness: endianness).map(\.bitPattern))
    }

    @inlinable
    public mutating func append(_ value: Int64, endianness: Binary.Endianness = .little) {
        append(contentsOf: [Byte](value, endianness: endianness).map(\.bitPattern))
    }

    @inlinable
    public mutating func append(_ value: Int, endianness: Binary.Endianness) {
        append(contentsOf: [Byte](value, endianness: endianness).map(\.bitPattern))
    }

    @inlinable
    public mutating func append(_ value: UInt, endianness: Binary.Endianness) {
        append(contentsOf: [Byte](value, endianness: endianness).map(\.bitPattern))
    }
}
#endif
