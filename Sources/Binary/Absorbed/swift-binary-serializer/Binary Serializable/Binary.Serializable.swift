#if Serializer
import Byte
public import Tagged

extension Binary {

    public protocol Serializable: Sendable {

        static func serialize<Buffer: RangeReplaceableCollection>(
            _ serializable: borrowing Self,
            into buffer: inout Buffer
        ) where Buffer.Element == Byte
    }
}

extension Binary.Serializable {

    public var bytes: [Byte] {
        var buffer: [Byte] = []
        Self.serialize(self, into: &buffer)
        return buffer
    }

    public func serialize<Buffer: RangeReplaceableCollection>(
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {
        Self.serialize(self, into: &buffer)
    }
}

extension Binary.Serializable {

    public static func serialize<Bytes: RangeReplaceableCollection>(
        _ serializable: Self
    ) -> Bytes where Bytes.Element == Byte {
        var buffer = Bytes()
        Self.serialize(serializable, into: &buffer)
        return buffer
    }
}

extension Binary.Serializable {

    public static func withSerializedBytes<R, E: Swift.Error>(
        _ value: Self,
        _ body: (borrowing Swift.Span<Byte>) throws(E) -> R
    ) throws(E) -> R {
        var buffer: ContiguousArray<Byte> = []
        Self.serialize(value, into: &buffer)
        return try body(buffer.span)
    }

    public func withSerializedBytes<R, E: Swift.Error>(
        _ body: (borrowing Swift.Span<Byte>) throws(E) -> R
    ) throws(E) -> R {
        try Self.withSerializedBytes(self, body)
    }
}

extension RangeReplaceableCollection<Byte> {

    @_disfavoredOverload
    public mutating func append<S: Binary.Serializable>(_ serializable: S) {
        S.serialize(serializable, into: &self)
    }
}

extension Array where Element == Byte {

    @_disfavoredOverload
    public init<S: Binary.Serializable>(_ serializable: S) {
        self = []
        S.serialize(serializable, into: &self)
    }
}

extension ContiguousArray where Element == Byte {

    @_disfavoredOverload
    public init<S: Binary.Serializable>(_ serializable: S) {
        self = []
        S.serialize(serializable, into: &self)
    }
}

extension StringProtocol {

    public init<T: Binary.Serializable>(_ value: T) {
        let typed: [Byte] = value.bytes
        self = Self(decoding: typed.lazy.map(\.bitPattern), as: UTF8.self)
    }
}

extension Binary.Serializable where Self: RawRepresentable, Self.RawValue: StringProtocol {

    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ serializable: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {

        let raw = serializable.rawValue
        buffer.append(contentsOf: raw.utf8.lazy.map(Byte.init(bitPattern:)))
    }
}

extension Binary.Serializable where Self: RawRepresentable, Self.RawValue == [Byte] {

    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ serializable: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {

        buffer.append(contentsOf: serializable.rawValue)
    }
}

extension Binary.Serializable where Self: RawRepresentable, Self.RawValue == [UInt8] {

    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ serializable: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {

        buffer.append(contentsOf: serializable.rawValue.lazy.map(Byte.init(bitPattern:)))
    }
}

extension Binary.Serializable where Self: RawRepresentable, Self.RawValue == [Byte] {

    public static func withSerializedBytes<R, E: Swift.Error>(
        _ value: Self,
        _ body: (borrowing Swift.Span<Byte>) throws(E) -> R
    ) throws(E) -> R {

        let bytes = value.rawValue
        return try body(bytes.span)
    }
}

extension Binary.Serializable where Self: RawRepresentable, Self.RawValue: StringProtocol {

    public static func withSerializedBytes<R, E: Swift.Error>(
        _ value: Self,
        _ body: (borrowing Swift.Span<Byte>) throws(E) -> R
    ) throws(E) -> R {

        let raw = value.rawValue
        let utf8: ContiguousArray<Byte> = ContiguousArray(raw.utf8.lazy.map(Byte.init(bitPattern:)))
        return try body(utf8.span)
    }
}

extension Binary.Serializable where Self: RawRepresentable, Self.RawValue: FixedWidthInteger {

    @inlinable
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ value: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {

        let raw = value.rawValue
        let bytes: [Byte]
        #if _endian(little)
            bytes = [Byte](raw, endianness: .little)
        #else
            bytes = [Byte](raw, endianness: .big)
        #endif
        buffer.append(contentsOf: bytes)
    }
}

extension Tagged: Binary.Serializable where Underlying: Binary.Serializable {

    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ value: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {
        Underlying.serialize(value.underlying, into: &buffer)
    }

    public static func withSerializedBytes<R, E: Swift.Error>(
        _ value: Self,
        _ body: (borrowing Swift.Span<Byte>) throws(E) -> R
    ) throws(E) -> R {
        try Underlying.withSerializedBytes(value.underlying, body)
    }
}

extension Array: Binary.Serializable where Element == Byte {

    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ value: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {
        buffer.append(contentsOf: value)
    }

    public static func withSerializedBytes<R, E: Swift.Error>(
        _ value: Self,
        _ body: (borrowing Swift.Span<Byte>) throws(E) -> R
    ) throws(E) -> R {
        try body(value.span)
    }
}

extension ContiguousArray: Binary.Serializable where Element == Byte {

    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ value: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {
        buffer.append(contentsOf: value)
    }

    public static func withSerializedBytes<R, E: Swift.Error>(
        _ value: Self,
        _ body: (borrowing Swift.Span<Byte>) throws(E) -> R
    ) throws(E) -> R {
        try body(value.span)
    }
}

extension ArraySlice: Binary.Serializable where Element == Byte {

    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ value: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {
        buffer.append(contentsOf: value)
    }
}
#endif
