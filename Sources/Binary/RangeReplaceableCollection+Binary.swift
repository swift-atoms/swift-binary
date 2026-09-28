public import Byte

extension RangeReplaceableCollection<Byte> {

    @inlinable
    public init(
        _ value: some FixedWidthInteger,
        endianness: Binary.Endianness = .little
    ) {
        self.init()
        reserveCapacity(MemoryLayout.size(ofValue: value))
        value.bytes(into: &self, endianness: endianness)
    }

    @inlinable
    public init<Values: Swift.Collection>(
        serializing values: Values,
        endianness: Binary.Endianness = .little
    ) where Values.Element: FixedWidthInteger {
        self.init()
        reserveCapacity(values.count * MemoryLayout<Values.Element>.size)
        for value in values {
            value.bytes(into: &self, endianness: endianness)
        }
    }

    @inlinable
    public mutating func append(
        _ value: some FixedWidthInteger,
        endianness: Binary.Endianness = .little
    ) {
        value.bytes(into: &self, endianness: endianness)
    }
}
