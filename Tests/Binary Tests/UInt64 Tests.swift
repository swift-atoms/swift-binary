import Binary
import Binary_Test_Support
import Byte
import Testing

@testable import Binary

@Suite
struct `UInt64 byte encoding preserves values and endianness` {
    @Suite struct `UInt64 values round trip across byte orders and numeric boundaries` {}
    @Suite struct `No UInt64 byte encoding boundary cases are defined` {}
    @Suite struct `No UInt64 byte encoding integration cases are defined` {}
    @Suite(.serialized) struct `No UInt64 byte encoding performance cases are defined` {}
}

extension `UInt64 byte encoding preserves values and endianness`.`UInt64 values round trip across byte orders and numeric boundaries` {

    @Test
    func `Integer encoding writes bytes in little endian order`() {
        let value: UInt64 = 0x1234_5678_9ABC_DEF0
        let bytes = value.bytes(endianness: .little)
        #expect(bytes == [0xF0, 0xDE, 0xBC, 0x9A, 0x78, 0x56, 0x34, 0x12].map { Byte(bitPattern: $0) })
    }

    @Test
    func `Integer encoding writes bytes in big endian order`() {
        let value: UInt64 = 0x1234_5678_9ABC_DEF0
        let bytes = value.bytes(endianness: .big)
        #expect(bytes == [0x12, 0x34, 0x56, 0x78, 0x9A, 0xBC, 0xDE, 0xF0].map { Byte(bitPattern: $0) })
    }

    @Test
    func `Integer encoding represents zero with bytes that are all zero`() {
        let value: UInt64 = 0
        #expect(
            value.bytes(endianness: .little) == [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00].map { Byte(bitPattern: $0) }
        )
        #expect(value.bytes(endianness: .big) == [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00].map { Byte(bitPattern: $0) })
    }

    @Test
    func `Integer encoding preserves the maximum unsigned value`() {
        let value: UInt64 = .max
        #expect(
            value.bytes(endianness: .little) == [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF].map { Byte(bitPattern: $0) }
        )
        #expect(value.bytes(endianness: .big) == [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF].map { Byte(bitPattern: $0) })
    }

    @Test
    func `Little endian encoding and decoding recover the original integer`() {

        let original: UInt64 = 0x1234_5678_9ABC_DEF0
        let bytes = original.bytes(endianness: .little)
        let recovered = UInt64(bytes: bytes, endianness: .little)
        #expect(recovered == original)
    }

    @Test
    func `Big endian encoding and decoding recover the original integer`() {

        let original: UInt64 = 0xABCD_EF01_2345_6789
        let bytes = original.bytes(endianness: .big)
        let recovered = UInt64(bytes: bytes, endianness: .big)
        #expect(recovered == original)
    }

    @Test
    func `Integer decoding and encoding recover the original bytes`() {

        let originalBytes = [0x12, 0x34, 0x56, 0x78, 0x9A, 0xBC, 0xDE, 0xF0].map { Byte(bitPattern: $0) }
        let value = UInt64(bytes: originalBytes, endianness: .little)
        let recoveredBytes = value?.bytes(endianness: .little)
        #expect(recoveredBytes == originalBytes)
    }

    @Test
    func `Byte conversion round trips a range of integer values`() {
        let values: [UInt64] = [0, 1, 0xFF, 0x1_0000_0000, 0x1234_5678_9ABC_DEF0, .max]

        for original in values {
            let bytesLE = original.bytes(endianness: .little)
            let recoveredLE = UInt64(bytes: bytesLE, endianness: .little)
            #expect(recoveredLE == original)

            let bytesBE = original.bytes(endianness: .big)
            let recoveredBE = UInt64(bytes: bytesBE, endianness: .big)
            #expect(recoveredBE == original)
        }
    }

    @Test
    func `byte count matches memory layout`() {
        let value: UInt64 = 0x1234_5678_9ABC_DEF0
        let bytes = value.bytes(endianness: .little)
        #expect(bytes.count == MemoryLayout<UInt64>.size)
        #expect(bytes.count == 8)
    }
}
