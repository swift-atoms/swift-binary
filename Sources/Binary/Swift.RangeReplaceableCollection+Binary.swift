public import Byte

extension Swift.RangeReplaceableCollection where Element: FixedWidthInteger {

    @inlinable
    public init?<Bytes: Swift.Collection>(
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
