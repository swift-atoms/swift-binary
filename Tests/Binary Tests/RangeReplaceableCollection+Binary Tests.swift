import Binary
import Byte
import Testing

enum `RangeReplaceableCollection+Binary Tests` {}

extension `RangeReplaceableCollection+Binary Tests` {
    @Suite
    struct `Range replaceable collections serialize and decode fixed width integers` {

        @Test
        func `Array materializes one integer as bytes`() {
            let bytes = [Byte](UInt32(0x1234_5678), endianness: .big)
            #expect(bytes == [0x12, 0x34, 0x56, 0x78].map { Byte(bitPattern: $0) })
        }

        @Test
        func `ContiguousArray materializes one integer as bytes`() {
            let bytes = ContiguousArray<Byte>(UInt32(0x1234_5678), endianness: .little)
            #expect(Array(bytes) == [0x78, 0x56, 0x34, 0x12].map { Byte(bitPattern: $0) })
        }

        @Test
        func `serialization accepts any Collection of integers`() {
            let values: ArraySlice<UInt16> = [1, 2, 3][...]
            let bytes = ContiguousArray<Byte>(serializing: values, endianness: .big)
            #expect(Array(bytes) == [0, 1, 0, 2, 0, 3].map { Byte(bitPattern: $0) })
        }

        @Test
        func `append writes an integer into any range replaceable byte collection`() {
            var bytes = ContiguousArray([0xFF].map { Byte(bitPattern: $0) })
            bytes.append(UInt16(0x1234), endianness: .little)
            #expect(Array(bytes) == [0xFF, 0x34, 0x12].map { Byte(bitPattern: $0) })
        }

        @Test
        func `appending a sized integer without endianness writes its own width`() {
            var bytes: [Byte] = []
            bytes.append(UInt8(0x01))
            bytes.append(Int8(-1))
            bytes.append(UInt16(0x0302))
            #expect(bytes == [0x01, 0xFF, 0x02, 0x03].map { Byte(bitPattern: $0) })
        }

        // swift-atoms/swift-binary#13: a bare literal defaults to `Int`, so
        // `bytes.append(0)` wrote eight bytes. It no longer compiles; a
        // platform-width integer must name its endianness.
        @Test
        func `appending a platform width integer names its endianness`() {
            var bytes: [Byte] = []
            bytes.append(Byte(0))
            #expect(bytes.count == 1)
            bytes.append(Int(1), endianness: .big)
            #expect(bytes.count == 1 + MemoryLayout<Int>.size)
            #expect(bytes.last == Byte(bitPattern: 1))
        }

        @Test
        func `Array decodes fixed width integers from bytes`() {
            let bytes = [0x01, 0x00, 0x02, 0x00].map { Byte(bitPattern: $0) }
            let values = [UInt16](bytes: bytes, endianness: .little)
            #expect(values == [1, 2])
        }

        @Test
        func `decoding can produce a non Array collection`() {
            let bytes = [0x00, 0x01, 0x00, 0x02].map { Byte(bitPattern: $0) }
            let values = ContiguousArray<UInt16>(bytes: bytes, endianness: .big)
            #expect(values.map { $0 } == [1, 2])
        }

        @Test
        func `decoding rejects an incomplete final integer`() {
            let bytes = [0x01, 0x00, 0x02].map { Byte(bitPattern: $0) }
            #expect([UInt16](bytes: bytes, endianness: .little) == nil)
        }
    }
}
