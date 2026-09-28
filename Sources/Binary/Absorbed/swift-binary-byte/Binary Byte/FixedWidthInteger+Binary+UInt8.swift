#if Byte
internal import Byte

extension FixedWidthInteger {

    @_disfavoredOverload
    @inlinable
    public static func bytes(_ value: Self, endianness: Binary.Endianness = .little) -> [UInt8] {
        let typed: [Byte] = Self.bytes(value, endianness: endianness)
        return typed.map(\.bitPattern)
    }

    @_disfavoredOverload
    @inlinable
    public func bytes(endianness: Binary.Endianness = .little) -> [UInt8] {
        Self.bytes(self, endianness: endianness)
    }

    @_disfavoredOverload
    @inlinable
    public init?(bytes: [UInt8], endianness: Binary.Endianness = .little) {
        self.init(bytes: bytes.map(Byte.init(bitPattern:)), endianness: endianness)
    }
}

extension Array where Element: FixedWidthInteger {

    @_disfavoredOverload
    @inlinable
    public init?<C: Swift.Collection>(bytes: C, endianness: Binary.Endianness = .little)
    where C.Element == UInt8 {
        self.init(bytes: bytes.lazy.map(Byte.init(bitPattern:)), endianness: endianness)
    }
}
#endif
