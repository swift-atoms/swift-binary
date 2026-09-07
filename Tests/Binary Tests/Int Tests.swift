import Binary
import Binary_Test_Support
import Byte
import Testing

@testable import Binary

@Suite
struct `Int serialization preserves signed values and byte order` {
    @Suite struct `Int values round trip through either byte order` {}
    @Suite struct `Int decoding rejects an incorrect byte count` {}
    @Suite struct `No Int serialization integration cases are defined` {}
    @Suite(.serialized) struct `No Int serialization performance cases are defined` {}
}

@Suite
struct `Int array serialization preserves element order and signed values` {
    @Suite struct `Int arrays round trip through either byte order` {}
    @Suite struct `Int array decoding rejects incomplete elements` {}
    @Suite struct `No Int array serialization integration cases are defined` {}
    @Suite(.serialized) struct `No Int array serialization performance cases are defined` {}
}

extension `Int serialization preserves signed values and byte order`.`Int values round trip through either byte order` {

    @Test
    func `round-trip conversion preserves value`() {
        let value: Int = 42
        let bytes = [Byte](value)
        let recovered = Int(bytes: bytes)
        #expect(recovered == value)
    }

    @Test
    func `little-endian encoding matches expected bytes`() {
        let value: Int = 0x0102_0304_0506_0708
        let bytes = [Byte](value, endianness: .little)

        #if arch(x86_64) || arch(arm64)

            #expect(bytes.count == 8)
            #expect(bytes[0].bitPattern == 0x08)
            #expect(bytes[1].bitPattern == 0x07)
            #expect(bytes[2].bitPattern == 0x06)
            #expect(bytes[3].bitPattern == 0x05)
            #expect(bytes[4].bitPattern == 0x04)
            #expect(bytes[5].bitPattern == 0x03)
            #expect(bytes[6].bitPattern == 0x02)
            #expect(bytes[7].bitPattern == 0x01)
        #else

            #expect(bytes.count == 4)
            #expect(bytes[0].bitPattern == 0x08)
            #expect(bytes[1].bitPattern == 0x07)
            #expect(bytes[2].bitPattern == 0x06)
            #expect(bytes[3].bitPattern == 0x05)
        #endif
    }

    @Test
    func `big-endian encoding matches expected bytes`() {
        let value: Int = 0x0102_0304_0506_0708
        let bytes = [Byte](value, endianness: .big)

        #if arch(x86_64) || arch(arm64)

            #expect(bytes.count == 8)
            #expect(bytes[0].bitPattern == 0x01)
            #expect(bytes[1].bitPattern == 0x02)
            #expect(bytes[2].bitPattern == 0x03)
            #expect(bytes[3].bitPattern == 0x04)
            #expect(bytes[4].bitPattern == 0x05)
            #expect(bytes[5].bitPattern == 0x06)
            #expect(bytes[6].bitPattern == 0x07)
            #expect(bytes[7].bitPattern == 0x08)
        #else

            #expect(bytes.count == 4)
            #expect(bytes[0].bitPattern == 0x05)
            #expect(bytes[1].bitPattern == 0x06)
            #expect(bytes[2].bitPattern == 0x07)
            #expect(bytes[3].bitPattern == 0x08)
        #endif
    }

    @Test
    func `Int decoding reconstructs a value from little endian bytes`() {
        let bytes = [0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08].map { Byte(bitPattern: $0) }
        let value = Int(bytes: bytes, endianness: .little)

        #if arch(x86_64) || arch(arm64)
            #expect(value == 0x0807_0605_0403_0201)
        #else

            let value32 = Int(bytes: Array(bytes.prefix(4)), endianness: .littleEndian)
            #expect(value32 == 0x0403_0201)
        #endif
    }

    @Test
    func `Int decoding reconstructs a value from big endian bytes`() {
        let bytes = [0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08].map { Byte(bitPattern: $0) }
        let value = Int(bytes: bytes, endianness: .big)

        #if arch(x86_64) || arch(arm64)
            #expect(value == 0x0102_0304_0506_0708)
        #else

            let value32 = Int(bytes: Array(bytes.prefix(4)), endianness: .bigEndian)
            #expect(value32 == 0x0102_0304)
        #endif
    }

    @Test
    func `Int zero survives byte encoding and decoding`() {
        let value: Int = 0
        let bytes = [Byte](value)
        let recovered = Int(bytes: bytes)
        #expect(recovered == value)
    }

    @Test
    func `Negative Int values survive byte encoding and decoding`() {
        let value: Int = -42
        let bytes = [Byte](value)
        let recovered = Int(bytes: bytes)
        #expect(recovered == value)
    }
}

extension `Int serialization preserves signed values and byte order`.`Int decoding rejects an incorrect byte count` {

    @Test
    func `decoding fails with incorrect byte count`() {
        let bytes = [0x01, 0x02, 0x03].map { Byte(bitPattern: $0) }
        let value = Int(bytes: bytes)
        #expect(value == nil)
    }
}

extension `Int array serialization preserves element order and signed values`.`Int arrays round trip through either byte order` {

    @Test
    func `Int arrays survive byte encoding and decoding`() {
        let values: [Int] = [1, 2, 3, 4, 5]
        let bytes = [Byte](serializing: values)
        let recovered = [Int](bytes: bytes)
        #expect(recovered == values)
    }

    @Test
    func `Empty Int arrays survive byte encoding and decoding`() {
        let values: [Int] = []
        let bytes = [Byte](serializing: values)
        let recovered = [Int](bytes: bytes)
        #expect(recovered == values)
    }

    @Test
    func `Int arrays round trip through both byte orders`() {
        let values: [Int] = [1, 2, 3]
        let bytesLE = [Byte](serializing: values, endianness: .little)
        let bytesBE = [Byte](serializing: values, endianness: .big)

        let recoveredLE = [Int](bytes: bytesLE, endianness: .little)
        let recoveredBE = [Int](bytes: bytesBE, endianness: .big)

        #expect(recoveredLE == values)
        #expect(recoveredBE == values)
    }

    @Test
    func `Int array byte encoding preserves negative elements`() {
        let values: [Int] = [-1, -2, -3]
        let bytes = [Byte](serializing: values)
        let recovered = [Int](bytes: bytes)
        #expect(recovered == values)
    }
}

extension `Int array serialization preserves element order and signed values`.`Int array decoding rejects incomplete elements` {

    @Test
    func `array decoding fails with incorrect byte count`() {

        let bytes = [0x01, 0x02, 0x03].map { Byte(bitPattern: $0) }
        let values = [Int](bytes: bytes)
        #expect(values == nil)
    }
}
