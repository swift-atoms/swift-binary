public import Binary_Endianness
public import Byte
public import Byte_Protocol

extension FixedWidthInteger {

    @inlinable
    public static func bytes(_ value: Self, endianness: Binary.Endianness = .little) -> [Byte] {
        var output: [Byte] = []
        output.reserveCapacity(MemoryLayout<Self>.size)
        value.bytes(into: &output, endianness: endianness)
        return output
    }

    @inlinable
    public func bytes(endianness: Binary.Endianness = .little) -> [Byte] {
        Self.bytes(self, endianness: endianness)
    }

    @inlinable
    public init?(bytes: some Swift.Collection<Byte>, endianness: Binary.Endianness = .little) {
        let size = MemoryLayout<Self>.size
        guard bytes.count == size else { return nil }
        var result: Self = 0
        var position = 0
        for byte in bytes {
            let index = endianness == .little ? position : size - 1 - position
            result |=
                Self(truncatingIfNeeded: byte.underlying) &<< Self(truncatingIfNeeded: index &* 8)
            position &+= 1
        }
        self = result
    }

    @inlinable
    public init?(_ bytes: borrowing Swift.Span<Byte>, endianness: Binary.Endianness = .little) {
        let size = MemoryLayout<Self>.size
        guard bytes.count == size else { return nil }
        var result: Self = 0
        (0..<size).forEach { position in
            let index = endianness == .little ? position : size - 1 - position
            result |=
                Self(truncatingIfNeeded: bytes[position].underlying)
                &<< Self(truncatingIfNeeded: index &* 8)
        }
        self = result
    }

    @inlinable
    public func bytes<Sink: RangeReplaceableCollection>(
        into sink: inout Sink,
        endianness: Binary.Endianness = .little
    ) where Sink.Element == Byte {
        let size = MemoryLayout<Self>.size
        (0..<size).forEach { position in
            let index = endianness == .little ? position : size - 1 - position
            sink.append(
                Byte(UInt8(truncatingIfNeeded: self &>> Self(truncatingIfNeeded: index &* 8)))
            )
        }
    }

    @inlinable
    public func bytes<Output: RangeReplaceableCollection>(
        endianness: Binary.Endianness = .little
    ) -> Output where Output.Element == Byte {
        var output = Output()
        output.reserveCapacity(MemoryLayout<Self>.size)
        bytes(into: &output, endianness: endianness)
        return output
    }

}

extension Array where Element: FixedWidthInteger {

    @inlinable
    public init?<C: Swift.Collection>(bytes: C, endianness: Binary.Endianness = .little)
    where C.Element == Byte {
        let elementSize = MemoryLayout<Element>.size
        guard bytes.count % elementSize == 0 else { return nil }

        var result: [Element] = []
        result.reserveCapacity(bytes.count / elementSize)

        let byteArray: [Byte] = .init(bytes)
        for i in stride(from: 0, to: byteArray.count, by: elementSize) {
            let chunk: [Byte] = .init(byteArray[i..<i + elementSize])
            guard let element = Element(bytes: chunk, endianness: endianness) else {
                return nil
            }
            result.append(element)
        }

        self = result
    }

}
