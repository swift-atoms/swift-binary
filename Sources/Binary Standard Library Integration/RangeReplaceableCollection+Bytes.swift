public import Byte_Protocol

extension RangeReplaceableCollection<Byte> {

    @inlinable

    public static func append<S: StringProtocol, Buffer: RangeReplaceableCollection>(
        utf8 string: S,
        to buffer: inout Buffer
    ) where Buffer.Element == Byte {
        buffer.append(contentsOf: string.utf8)
    }

    @inlinable
    public mutating func append(utf8 string: some StringProtocol) {
        Self.append(utf8: string, to: &self)
    }

    @inlinable

    public static func append<Buffer: RangeReplaceableCollection>(
        _ value: Byte,
        to buffer: inout Buffer
    ) where Buffer.Element == Byte {
        buffer.append(contentsOf: CollectionOfOne(value))
    }
}
