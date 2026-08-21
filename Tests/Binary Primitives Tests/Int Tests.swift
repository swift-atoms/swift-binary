import Binary_Primitives_Standard_Library_Integration
import Binary_Primitives_Test_Support
import Testing

@testable import Binary_Primitives

@Suite
struct `Int - Byte serialization Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
    @Suite(.serialized) struct Performance {}
}

@Suite
struct `[Int] - Byte serialization Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
    @Suite(.serialized) struct Performance {}
}

extension `Int - Byte serialization Tests`.Unit {

    @Test
    func `round-trip conversion preserves value`() {
        let value: Int = 42
        let bytes = [UInt8](value)
        let recovered = Int(bytes: bytes)
        #expect(recovered == value)
    }

    @Test
    func `little-endian encoding matches expected bytes`() {
        let value: Int = 0x0102_0304_0506_0708
        let bytes = [UInt8](value, endianness: .little)

        #if arch(x86_64) || arch(arm64)

            #expect(bytes.count == 8)
            #expect(bytes[0] == 0x08)
            #expect(bytes[1] == 0x07)
            #expect(bytes[2] == 0x06)
            #expect(bytes[3] == 0x05)
            #expect(bytes[4] == 0x04)
            #expect(bytes[5] == 0x03)
            #expect(bytes[6] == 0x02)
            #expect(bytes[7] == 0x01)
        #else

            #expect(bytes.count == 4)
            #expect(bytes[0] == 0x08)
            #expect(bytes[1] == 0x07)
            #expect(bytes[2] == 0x06)
            #expect(bytes[3] == 0x05)
        #endif
    }

    @Test
    func `big-endian encoding matches expected bytes`() {
        let value: Int = 0x0102_0304_0506_0708
        let bytes = [UInt8](value, endianness: .big)

        #if arch(x86_64) || arch(arm64)

            #expect(bytes.count == 8)
            #expect(bytes[0] == 0x01)
            #expect(bytes[1] == 0x02)
            #expect(bytes[2] == 0x03)
            #expect(bytes[3] == 0x04)
            #expect(bytes[4] == 0x05)
            #expect(bytes[5] == 0x06)
            #expect(bytes[6] == 0x07)
            #expect(bytes[7] == 0x08)
        #else

            #expect(bytes.count == 4)
            #expect(bytes[0] == 0x05)
            #expect(bytes[1] == 0x06)
            #expect(bytes[2] == 0x07)
            #expect(bytes[3] == 0x08)
        #endif
    }

    @Test
    func `decoding with little-endian`() {
        let bytes: [UInt8] = [0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08]
        let value = Int(bytes: bytes, endianness: .little)

        #if arch(x86_64) || arch(arm64)
            #expect(value == 0x0807_0605_0403_0201)
        #else

            let value32 = Int(bytes: Array(bytes.prefix(4)), endianness: .littleEndian)
            #expect(value32 == 0x0403_0201)
        #endif
    }

    @Test
    func `decoding with big-endian`() {
        let bytes: [UInt8] = [0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08]
        let value = Int(bytes: bytes, endianness: .big)

        #if arch(x86_64) || arch(arm64)
            #expect(value == 0x0102_0304_0506_0708)
        #else

            let value32 = Int(bytes: Array(bytes.prefix(4)), endianness: .bigEndian)
            #expect(value32 == 0x0102_0304)
        #endif
    }

    @Test
    func `zero value round-trip`() {
        let value: Int = 0
        let bytes = [UInt8](value)
        let recovered = Int(bytes: bytes)
        #expect(recovered == value)
    }

    @Test
    func `negative value round-trip`() {
        let value: Int = -42
        let bytes = [UInt8](value)
        let recovered = Int(bytes: bytes)
        #expect(recovered == value)
    }
}

extension `Int - Byte serialization Tests`.`Edge Case` {

    @Test
    func `decoding fails with incorrect byte count`() {
        let bytes: [UInt8] = [0x01, 0x02, 0x03]
        let value = Int(bytes: bytes)
        #expect(value == nil)
    }
}

extension `[Int] - Byte serialization Tests`.Unit {

    @Test
    func `array round-trip conversion`() {
        let values: [Int] = [1, 2, 3, 4, 5]
        let bytes = [UInt8](serializing: values)
        let recovered = [Int](bytes: bytes)
        #expect(recovered == values)
    }

    @Test
    func `empty array round-trip`() {
        let values: [Int] = []
        let bytes = [UInt8](serializing: values)
        let recovered = [Int](bytes: bytes)
        #expect(recovered == values)
    }

    @Test
    func `array with different endianness`() {
        let values: [Int] = [1, 2, 3]
        let bytesLE = [UInt8](serializing: values, endianness: .little)
        let bytesBE = [UInt8](serializing: values, endianness: .big)

        let recoveredLE = [Int](bytes: bytesLE, endianness: .little)
        let recoveredBE = [Int](bytes: bytesBE, endianness: .big)

        #expect(recoveredLE == values)
        #expect(recoveredBE == values)
    }

    @Test
    func `array with negative values`() {
        let values: [Int] = [-1, -2, -3]
        let bytes = [UInt8](serializing: values)
        let recovered = [Int](bytes: bytes)
        #expect(recovered == values)
    }
}

extension `[Int] - Byte serialization Tests`.`Edge Case` {

    @Test
    func `array decoding fails with incorrect byte count`() {

        let bytes: [UInt8] = [0x01, 0x02, 0x03]
        let values = [Int](bytes: bytes)
        #expect(values == nil)
    }
}
