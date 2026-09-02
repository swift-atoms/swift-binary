public import Binary_Endianness
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
    public init<Values: Collection>(
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

extension RangeReplaceableCollection where Element: FixedWidthInteger {

    @inlinable
    public init?<Bytes: Collection>(
        bytes: Bytes,
        endianness: Binary.Endianness = .little
    ) where Bytes.Element == Byte {
        let size = MemoryLayout<Element>.size
        guard bytes.count % size == 0 else { return nil }

        self.init()
        reserveCapacity(bytes.count / size)

        var start = bytes.startIndex
        while start != bytes.endIndex {
            let end = bytes.index(start, offsetBy: size)
            guard let element = Element(bytes: bytes[start..<end], endianness: endianness)
            else { return nil }
            append(element)
            start = end
        }
    }
}
