import Binary
import Binary_Test_Support
import Byte
import Testing

@testable import Binary

@Suite
struct `Int64 byte encoding preserves values and endianness` {
    @Suite struct `Int64 values round trip across byte orders and numeric boundaries` {}
    @Suite struct `No Int64 byte encoding boundary cases are defined` {}
    @Suite struct `No Int64 byte encoding integration cases are defined` {}
    @Suite(.serialized) struct `No Int64 byte encoding performance cases are defined` {}
}

extension `Int64 byte encoding preserves values and endianness`.`Int64 values round trip across byte orders and numeric boundaries` {

    @Test
    func `Integer encoding writes bytes in little endian order`() {
        let value: Int64 = 0x1234_5678_9ABC_DEF0
        let bytes = value.bytes(endianness: .little)
        #expect(bytes == [0xF0, 0xDE, 0xBC, 0x9A, 0x78, 0x56, 0x34, 0x12].map { Byte(bitPattern: $0) })
    }

    @Test
    func `Integer encoding writes bytes in big endian order`() {
        let value: Int64 = 0x1234_5678_9ABC_DEF0
        let bytes = value.bytes(endianness: .big)
        #expect(bytes == [0x12, 0x34, 0x56, 0x78, 0x9A, 0xBC, 0xDE, 0xF0].map { Byte(bitPattern: $0) })
    }

    @Test
    func `Integer encoding represents zero with bytes that are all zero`() {
        let value: Int64 = 0
        #expect(
            value.bytes(endianness: .little) == [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00].map { Byte(bitPattern: $0) }
        )
        #expect(value.bytes(endianness: .big) == [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00].map { Byte(bitPattern: $0) })
    }

    @Test
    func `Integer encoding preserves the maximum positive value`() {
        let value: Int64 = .max
        #expect(
            value.bytes(endianness: .little) == [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x7F].map { Byte(bitPattern: $0) }
        )
        #expect(value.bytes(endianness: .big) == [0x7F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF].map { Byte(bitPattern: $0) })
    }

    @Test
    func `Integer encoding preserves negative values`() {
        let value: Int64 = -1
        #expect(
            value.bytes(endianness: .little) == [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF].map { Byte(bitPattern: $0) }
        )
        #expect(value.bytes(endianness: .big) == [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF].map { Byte(bitPattern: $0) })
    }

    @Test
    func `Integer encoding preserves the minimum negative value`() {
        let value: Int64 = .min
        #expect(
            value.bytes(endianness: .little) == [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80].map { Byte(bitPattern: $0) }
        )
        #expect(value.bytes(endianness: .big) == [0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00].map { Byte(bitPattern: $0) })
    }

    @Test
    func `Little endian encoding and decoding recover the original integer`() {

        let original: Int64 = 0x1234_5678_9ABC_DEF0
        let bytes = original.bytes(endianness: .little)
        let recovered = Int64(bytes: bytes, endianness: .little)
        #expect(recovered == original)
    }

    @Test
    func `Big endian encoding and decoding recover the original integer`() {

        let original: Int64 = -0x1234_5678_9ABC_DEF0
        let bytes = original.bytes(endianness: .big)
        let recovered = Int64(bytes: bytes, endianness: .big)
        #expect(recovered == original)
    }

    @Test
    func `Byte conversion round trips a range of integer values`() {
        let values: [Int64] = [.min, -1_000_000_000_000, -1, 0, 1, 1_000_000_000_000, .max]

        for original in values {
            let bytesLE = original.bytes(endianness: .little)
            let recoveredLE = Int64(bytes: bytesLE, endianness: .little)
            #expect(recoveredLE == original)

            let bytesBE = original.bytes(endianness: .big)
            let recoveredBE = Int64(bytes: bytesBE, endianness: .big)
            #expect(recoveredBE == original)
        }
    }

    @Test
    func `byte count matches memory layout`() {
        let value: Int64 = 0x1234_5678_9ABC_DEF0
        let bytes = value.bytes(endianness: .little)
        #expect(bytes.count == MemoryLayout<Int64>.size)
        #expect(bytes.count == 8)
    }
}
