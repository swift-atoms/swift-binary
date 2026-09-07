import Binary
import Binary_Test_Support
import Byte
import Testing

@testable import Binary

@Suite
struct `Fixed width integer byte views preserve width and endianness` {
    @Suite struct `Integer byte views expose each byte in the requested order` {}
    @Suite struct `No integer byte view boundary cases are defined` {}
    @Suite struct `No integer byte view integration cases are defined` {}
    @Suite(.serialized) struct `No integer byte view performance cases are defined` {}
}

extension `Fixed width integer byte views preserve width and endianness`.`Integer byte views expose each byte in the requested order` {

    @Test
    func `UInt16 byte views follow little endian order`() {
        let value: UInt16 = 0x1234
        let bytes = value.bytes(endianness: .little)

        #expect(bytes.count == 2)
        #expect(bytes[0].bitPattern == 0x34)
        #expect(bytes[1].bitPattern == 0x12)
    }

    @Test
    func `UInt16 byte views follow big endian order`() {
        let value: UInt16 = 0x1234
        let bytes = value.bytes(endianness: .big)

        #expect(bytes.count == 2)
        #expect(bytes[0].bitPattern == 0x12)
        #expect(bytes[1].bitPattern == 0x34)
    }

    @Test
    func `UInt32 byte views follow little endian order`() {
        let value: UInt32 = 0x1234_5678
        let bytes = value.bytes(endianness: .little)

        #expect(bytes.count == 4)
        #expect(bytes == [0x78, 0x56, 0x34, 0x12].map { Byte(bitPattern: $0) })
    }

    @Test
    func `UInt32 byte views follow big endian order`() {
        let value: UInt32 = 0x1234_5678
        let bytes = value.bytes(endianness: .big)

        #expect(bytes.count == 4)
        #expect(bytes == [0x12, 0x34, 0x56, 0x78].map { Byte(bitPattern: $0) })
    }

    @Test
    func `bytes count matches memory layout`() {
        let value: UInt64 = 0x1234_5678_9ABC_DEF0
        let bytes = value.bytes()

        #expect(bytes.count == MemoryLayout<UInt64>.size)
    }

    @Test
    func `Zero integer byte views contain only zero bytes`() {
        let value: UInt32 = 0
        let bytes = value.bytes(endianness: .big)

        #expect(bytes.allSatisfy { $0.bitPattern == 0 })
        #expect(bytes.count == 4)
    }

    @Test
    func `bytes default endianness is little`() {
        let value: UInt16 = 0x1234
        let defaultBytes = value.bytes()
        let littleBytes = value.bytes(endianness: .little)

        #expect(defaultBytes == littleBytes)
    }

    @Test
    func `Int8 byte views preserve the stored byte`() {
        let value: Int8 = -1
        let bytes = value.bytes()

        #expect(bytes.count == 1)
        #expect(bytes[0].bitPattern == 0xFF)
    }

    @Test
    func `Int16 byte views preserve the requested byte order`() {
        let value: Int16 = 0x1234
        let bigEndian = value.bytes(endianness: .big)

        #expect(bigEndian.count == 2)
        #expect(bigEndian[0].bitPattern == 0x12)
        #expect(bigEndian[1].bitPattern == 0x34)
    }
}
