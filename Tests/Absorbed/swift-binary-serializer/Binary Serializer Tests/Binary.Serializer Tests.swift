#if Serializer
import Binary
import Binary_Serializer_Test_Support
import Testing

@testable import Binary

@Suite
struct `Binary.Serializer Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
    @Suite(.serialized) struct Performance {}
}

extension `Binary.Serializer Tests`.Unit {

    @Test
    func `serializeToArray produces expected bytes`() {
        let serializer = Binary.Serializer<UInt16> { value, buffer in
            buffer.append(Byte(bitPattern: UInt8(truncatingIfNeeded: value)))
            buffer.append(Byte(bitPattern: UInt8(truncatingIfNeeded: value >> 8)))
        }

        let bytes = serializer.serializeToArray(0x1234)
        #expect(bytes == [Byte(bitPattern: 0x34), Byte(bitPattern: 0x12)])
    }

    @Test
    func `serializeAppending appends to existing buffer`() {
        let serializer = Binary.Serializer<UInt8> { value, buffer in
            buffer.append(Byte(bitPattern: value))
        }

        var buffer: [Byte] = [Byte(bitPattern: 0xAA)]
        serializer.serializeAppending(0x42, to: &buffer)
        #expect(buffer == [Byte(bitPattern: 0xAA), Byte(bitPattern: 0x42)])
    }

    @Test
    func `UInt8 serializer writes one byte`() {
        let serializer = UInt8.serializer(endianness: .big)
        let bytes = serializer.serializeToArray(0x42)
        #expect(bytes == [Byte(bitPattern: 0x42)])
    }

    @Test
    func `UInt16 little-endian serializer writes low byte first`() {
        let serializer = UInt16.serializer(endianness: .little)
        let bytes = serializer.serializeToArray(0x1234)
        #expect(bytes == [Byte(bitPattern: 0x34), Byte(bitPattern: 0x12)])
    }

    @Test
    func `UInt16 big-endian serializer writes high byte first`() {
        let serializer = UInt16.serializer(endianness: .big)
        let bytes = serializer.serializeToArray(0x1234)
        #expect(bytes == [Byte(bitPattern: 0x12), Byte(bitPattern: 0x34)])
    }

    @Test
    func `UInt32 little-endian serializer writes 4 bytes low-first`() {
        let serializer = UInt32.serializer(endianness: .little)
        let bytes = serializer.serializeToArray(0x1234_5678)
        #expect(bytes == [Byte(bitPattern: 0x78), Byte(bitPattern: 0x56), Byte(bitPattern: 0x34), Byte(bitPattern: 0x12)])
    }

    @Test
    func `UInt64 big-endian serializer writes 8 bytes high-first`() {
        let serializer = UInt64.serializer(endianness: .big)
        let bytes = serializer.serializeToArray(0x0102_0304_0506_0708)
        #expect(
            bytes == [
                Byte(bitPattern: 0x01), Byte(bitPattern: 0x02), Byte(bitPattern: 0x03), Byte(bitPattern: 0x04),
                Byte(bitPattern: 0x05), Byte(bitPattern: 0x06), Byte(bitPattern: 0x07), Byte(bitPattern: 0x08),
            ]
        )
    }

    @Test
    func `Int8 serializer writes sign-extended byte`() {
        let serializer = Int8.serializer(endianness: .big)
        let bytes = serializer.serializeToArray(-1)
        #expect(bytes == [Byte(bitPattern: 0xFF)])
    }
}

extension `Binary.Serializer Tests`.`Edge Case` {

    @Test
    func `serializing UInt16 zero produces two zero bytes`() {
        let serializer = UInt16.serializer(endianness: .little)
        let bytes = serializer.serializeToArray(0)
        #expect(bytes == [Byte(bitPattern: 0x00), Byte(bitPattern: 0x00)])
    }

    @Test
    func `serializing UInt16 max big-endian produces two FF bytes`() {
        let serializer = UInt16.serializer(endianness: .big)
        let bytes = serializer.serializeToArray(UInt16.max)
        #expect(bytes == [Byte(bitPattern: 0xFF), Byte(bitPattern: 0xFF)])
    }
}

extension `Binary.Serializer Tests`.Integration {

    @Test
    func `multiple serializers compose into one buffer`() {
        let u16 = UInt16.serializer(endianness: .little)
        let u32 = UInt32.serializer(endianness: .big)

        var buffer: [Byte] = []
        u16.serializeAppending(0x1234, to: &buffer)
        u32.serializeAppending(0xCAFE_BABE, to: &buffer)

        #expect(
            buffer == [
                Byte(bitPattern: 0x34), Byte(bitPattern: 0x12),
                Byte(bitPattern: 0xCA), Byte(bitPattern: 0xFE), Byte(bitPattern: 0xBA), Byte(bitPattern: 0xBE),
            ]
        )
    }
}

@Suite struct `Explicit raw value serialization` {
    @Test func `string backed values use the selected binary representation`() {
        #expect(Binary.Serializer<RawCommand>.rawValue.serializeToArray(.ok).map(\.bitPattern) == [79, 75])
    }
    @Test func `integer backed values select endianness explicitly`() {
        let value = RawNumber(rawValue: 0x1234)
        #expect(Binary.Serializer<RawNumber>.rawValue(endianness: .big).serializeToArray(value).map(\.bitPattern) == [0x12, 0x34])
        #expect(Binary.Serializer<RawNumber>.rawValue(endianness: .little).serializeToArray(value).map(\.bitPattern) == [0x34, 0x12])
    }
}
private enum RawCommand: String { case ok = "OK" }
private struct RawNumber: RawRepresentable { var rawValue: UInt16 }
#endif
