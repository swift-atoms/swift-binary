import Binary
import Binary_Test_Support
import Byte
import Testing

@testable import Binary

@Suite
struct `Int16 byte encoding preserves values and endianness` {
    @Suite struct `Int16 values round trip across byte orders and numeric boundaries` {}
    @Suite struct `No Int16 byte encoding boundary cases are defined` {}
    @Suite struct `No Int16 byte encoding integration cases are defined` {}
    @Suite(.serialized) struct `No Int16 byte encoding performance cases are defined` {}
}

extension `Int16 byte encoding preserves values and endianness`.`Int16 values round trip across byte orders and numeric boundaries` {

    @Test
    func `Integer encoding writes bytes in little endian order`() {
        let value: Int16 = 0x1234
        let bytes = value.bytes(endianness: .little)
        #expect(bytes == [0x34, 0x12].map { Byte(bitPattern: $0) })
    }

    @Test
    func `Integer encoding writes bytes in big endian order`() {
        let value: Int16 = 0x1234
        let bytes = value.bytes(endianness: .big)
        #expect(bytes == [0x12, 0x34].map { Byte(bitPattern: $0) })
    }

    @Test
    func `Integer encoding represents zero with bytes that are all zero`() {
        let value: Int16 = 0
        #expect(value.bytes(endianness: .little) == [0x00, 0x00].map { Byte(bitPattern: $0) })
        #expect(value.bytes(endianness: .big) == [0x00, 0x00].map { Byte(bitPattern: $0) })
    }

    @Test
    func `Integer encoding preserves the maximum positive value`() {
        let value: Int16 = .max
        #expect(value.bytes(endianness: .little) == [0xFF, 0x7F].map { Byte(bitPattern: $0) })
        #expect(value.bytes(endianness: .big) == [0x7F, 0xFF].map { Byte(bitPattern: $0) })
    }

    @Test
    func `Integer encoding preserves negative values`() {
        let value: Int16 = -1
        #expect(value.bytes(endianness: .little) == [0xFF, 0xFF].map { Byte(bitPattern: $0) })
        #expect(value.bytes(endianness: .big) == [0xFF, 0xFF].map { Byte(bitPattern: $0) })
    }

    @Test
    func `Integer encoding preserves the minimum negative value`() {
        let value: Int16 = .min
        #expect(value.bytes(endianness: .little) == [0x00, 0x80].map { Byte(bitPattern: $0) })
        #expect(value.bytes(endianness: .big) == [0x80, 0x00].map { Byte(bitPattern: $0) })
    }

    @Test
    func `Little endian encoding and decoding recover the original integer`() {

        let original: Int16 = 0x1234
        let bytes = original.bytes(endianness: .little)
        let recovered = Int16(bytes: bytes, endianness: .little)
        #expect(recovered == original)
    }

    @Test
    func `Big endian encoding and decoding recover the original integer`() {

        let original: Int16 = -0x1234
        let bytes = original.bytes(endianness: .big)
        let recovered = Int16(bytes: bytes, endianness: .big)
        #expect(recovered == original)
    }

    @Test
    func `Byte conversion round trips a range of integer values`() {
        let values: [Int16] = [.min, -1000, -1, 0, 1, 1000, .max]

        for original in values {
            let bytesLE = original.bytes(endianness: .little)
            let recoveredLE = Int16(bytes: bytesLE, endianness: .little)
            #expect(recoveredLE == original)

            let bytesBE = original.bytes(endianness: .big)
            let recoveredBE = Int16(bytes: bytesBE, endianness: .big)
            #expect(recoveredBE == original)
        }
    }

    @Test
    func `byte count matches memory layout`() {
        let value: Int16 = 0x1234
        let bytes = value.bytes(endianness: .little)
        #expect(bytes.count == MemoryLayout<Int16>.size)
        #expect(bytes.count == 2)
    }
}
