import Binary
import Binary_Test_Support
import Byte
import Testing

@testable import Binary

@Suite
struct `UInt16 byte encoding preserves values and endianness` {
    @Suite struct `UInt16 values round trip across byte orders and numeric boundaries` {}
    @Suite struct `No UInt16 byte encoding boundary cases are defined` {}
    @Suite struct `UInt16 byte encoding interoperates with different collection views` {}
    @Suite(.serialized) struct `No UInt16 byte encoding performance cases are defined` {}
}

extension `UInt16 byte encoding preserves values and endianness`.`UInt16 values round trip across byte orders and numeric boundaries` {

    @Test
    func `Integer encoding writes bytes in little endian order`() {
        let value: UInt16 = 0x1234
        let bytes = value.bytes(endianness: .little)
        #expect(bytes == [0x34, 0x12].map { Byte(bitPattern: $0) })
    }

    @Test
    func `Integer encoding writes bytes in big endian order`() {
        let value: UInt16 = 0x1234
        let bytes = value.bytes(endianness: .big)
        #expect(bytes == [0x12, 0x34].map { Byte(bitPattern: $0) })
    }

    @Test
    func `Integer encoding represents zero with bytes that are all zero`() {
        let value: UInt16 = 0
        #expect(value.bytes(endianness: .little) == [0x00, 0x00].map { Byte(bitPattern: $0) })
        #expect(value.bytes(endianness: .big) == [0x00, 0x00].map { Byte(bitPattern: $0) })
    }

    @Test
    func `Integer encoding preserves the maximum unsigned value`() {
        let value: UInt16 = .max
        #expect(value.bytes(endianness: .little) == [0xFF, 0xFF].map { Byte(bitPattern: $0) })
        #expect(value.bytes(endianness: .big) == [0xFF, 0xFF].map { Byte(bitPattern: $0) })
    }

    @Test
    func `Little endian encoding and decoding recover the original integer`() {

        let original: UInt16 = 0x1234
        let bytes = original.bytes(endianness: .little)
        let recovered = UInt16(bytes: bytes, endianness: .little)
        #expect(recovered == original)
    }

    @Test
    func `Big endian encoding and decoding recover the original integer`() {

        let original: UInt16 = 0xABCD
        let bytes = original.bytes(endianness: .big)
        let recovered = UInt16(bytes: bytes, endianness: .big)
        #expect(recovered == original)
    }

    @Test
    func `Integer decoding and encoding recover the original bytes`() {

        let originalBytes = [0x12, 0x34].map { Byte(bitPattern: $0) }
        let value = UInt16(bytes: originalBytes, endianness: .little)
        let recoveredBytes = value?.bytes(endianness: .little)
        #expect(recoveredBytes == originalBytes)
    }

    @Test
    func `Byte conversion round trips a range of integer values`() {
        let values: [UInt16] = [0, 1, 0xFF, 0x100, 0x1234, 0xABCD, .max]

        for original in values {
            let bytesLE = original.bytes(endianness: .little)
            let recoveredLE = UInt16(bytes: bytesLE, endianness: .little)
            #expect(recoveredLE == original)

            let bytesBE = original.bytes(endianness: .big)
            let recoveredBE = UInt16(bytes: bytesBE, endianness: .big)
            #expect(recoveredBE == original)
        }
    }

    @Test
    func `byte count matches memory layout`() {
        let value: UInt16 = 0x1234
        let bytes = value.bytes(endianness: .little)
        #expect(bytes.count == MemoryLayout<UInt16>.size)
        #expect(bytes.count == 2)
    }
}

extension `UInt16 byte encoding preserves values and endianness`.`UInt16 byte encoding interoperates with different collection views` {

    @Test
    func `Array byte conversion round trips UInt16 values`() {
        let values: [UInt16] = [100, 200, 300]
        let bytes = [Byte](serializing: values)
        let recovered = [UInt16](bytes: bytes)
        #expect(recovered == values)
    }

    @Test
    func `collection works with ArraySlice`() {
        let values: [UInt16] = [100, 200, 300, 400, 500]
        let slice = values[1...3]

        let bytes = [Byte](serializing: slice)
        let recovered = [UInt16](bytes: bytes)
        #expect(recovered == Array(slice))
    }

    @Test
    func `collection works with ContiguousArray`() {
        let values = ContiguousArray<UInt16>([100, 200, 300])
        let bytes = [Byte](serializing: values)
        let recovered = [UInt16](bytes: bytes)
        #expect(recovered == Array(values))
    }

    @Test
    func `collection works with prefix`() {
        let values: [UInt16] = [100, 200, 300, 400, 500]
        let prefix = values.prefix(3)

        let bytes = [Byte](serializing: prefix)
        let recovered = [UInt16](bytes: bytes)
        #expect(recovered == Array(prefix))
    }

    @Test
    func `collection works with suffix`() {
        let values: [UInt16] = [100, 200, 300, 400, 500]
        let suffix = values.suffix(2)

        let bytes = [Byte](serializing: suffix)
        let recovered = [UInt16](bytes: bytes)
        #expect(recovered == Array(suffix))
    }

    @Test
    func `UInt16 collection encoding respects the requested byte order`() {
        let values: [UInt16] = [0x0102, 0x0304]

        let bytesLE = [Byte](serializing: values, endianness: .little)
        let bytesBE = [Byte](serializing: values, endianness: .big)

        #expect(bytesLE == [0x02, 0x01, 0x04, 0x03].map { Byte(bitPattern: $0) })

        #expect(bytesBE == [0x01, 0x02, 0x03, 0x04].map { Byte(bitPattern: $0) })
    }
}
