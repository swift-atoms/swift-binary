import Binary_Endianness
import Binary_Standard_Library_Integration
import Binary_Test_Support
import Byte
import Byte_Protocol
import Testing

@testable import Binary

@Suite
struct `Int16 - Byte encoding Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
    @Suite(.serialized) struct Performance {}
}

extension `Int16 - Byte encoding Tests`.Unit {

    @Test
    func `encode to bytes little-endian`() {
        let value: Int16 = 0x1234
        let bytes = value.bytes(endianness: .little)
        #expect(bytes == [0x34, 0x12])
    }

    @Test
    func `encode to bytes big-endian`() {
        let value: Int16 = 0x1234
        let bytes = value.bytes(endianness: .big)
        #expect(bytes == [0x12, 0x34])
    }

    @Test
    func `encode zero`() {
        let value: Int16 = 0
        #expect(value.bytes(endianness: .little) == [0x00, 0x00])
        #expect(value.bytes(endianness: .big) == [0x00, 0x00])
    }

    @Test
    func `encode positive max value`() {
        let value: Int16 = .max
        #expect(value.bytes(endianness: .little) == [0xFF, 0x7F])
        #expect(value.bytes(endianness: .big) == [0x7F, 0xFF])
    }

    @Test
    func `encode negative value`() {
        let value: Int16 = -1
        #expect(value.bytes(endianness: .little) == [0xFF, 0xFF])
        #expect(value.bytes(endianness: .big) == [0xFF, 0xFF])
    }

    @Test
    func `encode negative min value`() {
        let value: Int16 = .min
        #expect(value.bytes(endianness: .little) == [0x00, 0x80])
        #expect(value.bytes(endianness: .big) == [0x80, 0x00])
    }

    @Test
    func `encode-decode isomorphism little-endian`() {

        let original: Int16 = 0x1234
        let bytes = original.bytes(endianness: .little)
        let recovered = Int16(bytes: bytes, endianness: .little)
        #expect(recovered == original)
    }

    @Test
    func `encode-decode isomorphism big-endian`() {

        let original: Int16 = -0x1234
        let bytes = original.bytes(endianness: .big)
        let recovered = Int16(bytes: bytes, endianness: .big)
        #expect(recovered == original)
    }

    @Test
    func `round-trip multiple values`() {
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
