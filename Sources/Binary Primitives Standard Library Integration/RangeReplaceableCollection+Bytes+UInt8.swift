internal import Byte_Primitives

extension RangeReplaceableCollection<UInt8> {

    @_disfavoredOverload
    @inlinable

    public static func append<S: StringProtocol, Buffer: RangeReplaceableCollection>(
        utf8 string: S,
        to buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        buffer.append(contentsOf: string.utf8)
    }

    @_disfavoredOverload
    @inlinable
    public mutating func append(utf8 string: some StringProtocol) {
        Self.append(utf8: string, to: &self)
    }

    @_disfavoredOverload
    @inlinable

    public static func append<Buffer: RangeReplaceableCollection>(
        _ value: UInt8,
        to buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        buffer.append(contentsOf: CollectionOfOne(value))
    }
}
