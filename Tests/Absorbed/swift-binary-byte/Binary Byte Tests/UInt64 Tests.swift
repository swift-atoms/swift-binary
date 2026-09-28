#if Byte
import Binary
import Byte
import Testing

@Suite
struct `UInt64 - Byte encoding Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
    @Suite(.serialized) struct Performance {}
}

extension `UInt64 - Byte encoding Tests`.Unit {

    @Test
    func `encode to bytes little-endian`() {
        let value: UInt64 = 0x1234_5678_9ABC_DEF0
        let bytes = value.bytes(endianness: .little)
        #expect(bytes == [Byte(bitPattern: 0xF0), Byte(bitPattern: 0xDE), Byte(bitPattern: 0xBC), Byte(bitPattern: 0x9A), Byte(bitPattern: 0x78), Byte(bitPattern: 0x56), Byte(bitPattern: 0x34), Byte(bitPattern: 0x12)])
    }

    @Test
    func `encode to bytes big-endian`() {
        let value: UInt64 = 0x1234_5678_9ABC_DEF0
        let bytes = value.bytes(endianness: .big)
        #expect(bytes == [Byte(bitPattern: 0x12), Byte(bitPattern: 0x34), Byte(bitPattern: 0x56), Byte(bitPattern: 0x78), Byte(bitPattern: 0x9A), Byte(bitPattern: 0xBC), Byte(bitPattern: 0xDE), Byte(bitPattern: 0xF0)])
    }

    @Test
    func `encode zero`() {
        let value: UInt64 = 0
        #expect(
            value.bytes(endianness: .little) == [Byte(bitPattern: 0x00), Byte(bitPattern: 0x00), Byte(bitPattern: 0x00), Byte(bitPattern: 0x00), Byte(bitPattern: 0x00), Byte(bitPattern: 0x00), Byte(bitPattern: 0x00), Byte(bitPattern: 0x00)]
        )
        #expect(value.bytes(endianness: .big) == [Byte(bitPattern: 0x00), Byte(bitPattern: 0x00), Byte(bitPattern: 0x00), Byte(bitPattern: 0x00), Byte(bitPattern: 0x00), Byte(bitPattern: 0x00), Byte(bitPattern: 0x00), Byte(bitPattern: 0x00)])
    }

    @Test
    func `encode max value`() {
        let value: UInt64 = .max
        #expect(
            value.bytes(endianness: .little) == [Byte(bitPattern: 0xFF), Byte(bitPattern: 0xFF), Byte(bitPattern: 0xFF), Byte(bitPattern: 0xFF), Byte(bitPattern: 0xFF), Byte(bitPattern: 0xFF), Byte(bitPattern: 0xFF), Byte(bitPattern: 0xFF)]
        )
        #expect(value.bytes(endianness: .big) == [Byte(bitPattern: 0xFF), Byte(bitPattern: 0xFF), Byte(bitPattern: 0xFF), Byte(bitPattern: 0xFF), Byte(bitPattern: 0xFF), Byte(bitPattern: 0xFF), Byte(bitPattern: 0xFF), Byte(bitPattern: 0xFF)])
    }

    @Test
    func `encode-decode isomorphism little-endian`() {

        let original: UInt64 = 0x1234_5678_9ABC_DEF0
        let bytes = original.bytes(endianness: .little)
        let recovered = UInt64(bytes: bytes, endianness: .little)
        #expect(recovered == original)
    }

    @Test
    func `encode-decode isomorphism big-endian`() {

        let original: UInt64 = 0xABCD_EF01_2345_6789
        let bytes = original.bytes(endianness: .big)
        let recovered = UInt64(bytes: bytes, endianness: .big)
        #expect(recovered == original)
    }

    @Test
    func `decode-encode isomorphism`() {

        let originalBytes: [Byte] = [Byte(bitPattern: 0x12), Byte(bitPattern: 0x34), Byte(bitPattern: 0x56), Byte(bitPattern: 0x78), Byte(bitPattern: 0x9A), Byte(bitPattern: 0xBC), Byte(bitPattern: 0xDE), Byte(bitPattern: 0xF0)]
        let value = UInt64(bytes: originalBytes, endianness: .little)
        let recoveredBytes = value?.bytes(endianness: .little)
        #expect(recoveredBytes == originalBytes)
    }

    @Test
    func `round-trip multiple values`() {
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
#endif
