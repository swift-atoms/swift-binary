import Binary_Standard_Library_Integration
import Testing

@testable import Binary

@Suite
struct `Array+Bytes Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
    @Suite(.serialized) struct Performance {}
}

extension `Array+Bytes Tests`.Unit {

    @Test
    func `array from integer little endian`() {
        let bytes = [UInt8](UInt16(0x1234), endianness: .little)
        #expect(bytes == [0x34, 0x12])
    }

    @Test
    func `array from integer big endian`() {
        let bytes = [UInt8](UInt16(0x1234), endianness: .big)
        #expect(bytes == [0x12, 0x34])
    }

    @Test
    func `array from integer default endianness is little`() {
        let bytes = [UInt8](UInt16(0x1234))
        #expect(bytes == [0x34, 0x12])
    }

    @Test(arguments: [
        (UInt32(0x1234_5678), Binary.Endianness.little, [0x78, 0x56, 0x34, 0x12] as [UInt8]),
        (UInt32(0x1234_5678), Binary.Endianness.big, [0x12, 0x34, 0x56, 0x78] as [UInt8]),
    ])
    func `array from UInt32 with different endianness`(
        testCase: (UInt32, Binary.Endianness, [UInt8])
    ) {
        let (value, endianness, expected) = testCase
        let bytes = [UInt8](value, endianness: endianness)
        #expect(bytes == expected)
    }

    @Test
    func `array from collection of integers`() {
        let values: [UInt16] = [1, 2, 3]
        let bytes = [UInt8](serializing: values, endianness: .little)
        #expect(bytes.count == 6)
        #expect(bytes == [1, 0, 2, 0, 3, 0])
    }

    @Test
    func `array from empty collection`() {
        let values: [UInt16] = []
        let bytes = [UInt8](serializing: values, endianness: .little)
        #expect(bytes.isEmpty)
    }

    @Test
    func `array from collection big endian`() {
        let values: [UInt16] = [0x1234, 0x5678]
        let bytes = [UInt8](serializing: values, endianness: .big)
        #expect(bytes == [0x12, 0x34, 0x56, 0x78])
    }

    @Test
    func `array from UTF8 string`() {
        let bytes = [UInt8](utf8: "Hi")
        #expect(bytes == [72, 105])
    }

    @Test
    func `array from UTF8 empty string`() {
        let bytes = [UInt8](utf8: "")
        #expect(bytes.isEmpty)
    }

    @Test
    func `array from UTF8 unicode string`() {
        let bytes = [UInt8](utf8: "Hello")
        #expect(bytes.count > 0)
        #expect(String(decoding: bytes, as: UTF8.self) == "Hello")
    }

    @Test
    func `split by separator`() {
        let data: [UInt8] = [1, 2, 0, 0, 3, 4, 0, 0, 5]
        let parts = data.split(separator: [0, 0])
        #expect(parts.count == 3)
        #expect(parts[0] == [1, 2])
        #expect(parts[1] == [3, 4])
        #expect(parts[2] == [5])
    }

    @Test
    func `split static method`() {
        let data: [UInt8] = [1, 2, 0, 3, 4]
        let parts = [UInt8].split(data, separator: [0])
        #expect(parts.count == 2)
        #expect(parts[0] == [1, 2])
        #expect(parts[1] == [3, 4])
    }

    @Test
    func `split with empty separator returns original array`() {
        let data: [UInt8] = [1, 2, 3]
        let parts = data.split(separator: [])
        #expect(parts.count == 1)
        #expect(parts[0] == data)
    }

    @Test
    func `split when separator not found`() {
        let data: [UInt8] = [1, 2, 3, 4]
        let parts = data.split(separator: [99])
        #expect(parts.count == 1)
        #expect(parts[0] == data)
    }
}

@Suite
struct `[[UInt8]] - Joining Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
    @Suite(.serialized) struct Performance {}
}

extension `[[UInt8]] - Joining Tests`.Unit {

    @Test
    func `join with separator`() {
        let parts: [[UInt8]] = [[1, 2], [3, 4], [5]]
        let joined = parts.joined(separator: [0, 0])
        #expect(joined == [1, 2, 0, 0, 3, 4, 0, 0, 5])
    }

    @Test
    func `join without separator`() {
        let parts: [[UInt8]] = [[1, 2], [3, 4], [5]]
        let joined = parts.joined()
        #expect(joined == [1, 2, 3, 4, 5])
    }

    @Test
    func `join empty array`() {
        let parts: [[UInt8]] = []
        let joined = parts.joined(separator: [0])
        #expect(joined.isEmpty)
    }

    @Test
    func `join single element`() {
        let parts: [[UInt8]] = [[1, 2, 3]]
        let joined = parts.joined(separator: [0])
        #expect(joined == [1, 2, 3])
    }

    @Test
    func `join with empty separator`() {
        let parts: [[UInt8]] = [[1], [2], [3]]
        let joined = parts.joined(separator: [])
        #expect(joined == [1, 2, 3])
    }

    @Test
    func `join preserves capacity efficiency`() {
        let parts: [[UInt8]] = [[1, 2], [3, 4], [5, 6]]
        let joined = parts.joined(separator: [0])

        #expect(joined.count == 8)
    }
}
