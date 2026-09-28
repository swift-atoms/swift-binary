#if Serializer
internal import Byte

extension Binary.Serializable {

    @_disfavoredOverload
    public func serialize<Buffer: RangeReplaceableCollection>(
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        var byteBuffer: ContiguousArray<Byte> = []
        Self.serialize(self, into: &byteBuffer)
        buffer.append(contentsOf: byteBuffer.lazy.map(\.bitPattern))
    }

    @_disfavoredOverload
    public static func withSerializedBytes<R, E: Swift.Error>(
        _ value: Self,
        _ body: (borrowing Swift.Span<UInt8>) throws(E) -> R
    ) throws(E) -> R {
        var byteBuffer: ContiguousArray<Byte> = []
        Self.serialize(value, into: &byteBuffer)
        let uint8Buffer = ContiguousArray<UInt8>(byteBuffer.lazy.map(\.bitPattern))
        return try body(uint8Buffer.span)
    }

    @_disfavoredOverload
    public func withSerializedBytes<R, E: Swift.Error>(
        _ body: (borrowing Swift.Span<UInt8>) throws(E) -> R
    ) throws(E) -> R {
        try Self.withSerializedBytes(self, body)
    }
}

extension RangeReplaceableCollection<UInt8> {

    @_disfavoredOverload
    public mutating func append<S: Binary.Serializable>(_ serializable: S) {
        var byteBuffer: ContiguousArray<Byte> = []
        S.serialize(serializable, into: &byteBuffer)
        self.append(contentsOf: byteBuffer.lazy.map(\.bitPattern))
    }
}

extension Array where Element == UInt8 {

    @_disfavoredOverload
    public init<S: Binary.Serializable>(_ serializable: S) {
        var typed: [Byte] = []
        S.serialize(serializable, into: &typed)
        self = typed.map(\.bitPattern)
    }
}

extension ContiguousArray where Element == UInt8 {

    @_disfavoredOverload
    public init<S: Binary.Serializable>(_ serializable: S) {
        var typed: ContiguousArray<Byte> = []
        S.serialize(serializable, into: &typed)
        self = ContiguousArray(typed.map(\.bitPattern))
    }
}

extension String {

    @_disfavoredOverload
    public init(_ bytes: [UInt8]) {
        self = String(decoding: bytes, as: UTF8.self)
    }

    @_disfavoredOverload
    public init(_ bytes: ArraySlice<UInt8>) {
        self = String(decoding: bytes, as: UTF8.self)
    }
}
#endif
