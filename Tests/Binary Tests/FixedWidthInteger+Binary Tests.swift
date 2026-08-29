import Binary_Endianness
import Binary_Standard_Library_Integration
import Binary_Test_Support
import Byte
import Byte_Protocol
import Testing

@testable import Binary

@Suite
struct `FixedWidthInteger+Binary Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
    @Suite(.serialized) struct Performance {}
}

extension `FixedWidthInteger+Binary Tests`.Unit {

    @Test
    func `bytes with little endian UInt16`() {
        let value: UInt16 = 0x1234
        let bytes = value.bytes(endianness: .little)

        #expect(bytes.count == 2)
        #expect(bytes[0] == 0x34)
        #expect(bytes[1] == 0x12)
    }

    @Test
    func `bytes with big endian UInt16`() {
        let value: UInt16 = 0x1234
        let bytes = value.bytes(endianness: .big)

        #expect(bytes.count == 2)
        #expect(bytes[0] == 0x12)
        #expect(bytes[1] == 0x34)
    }

    @Test
    func `bytes with little endian UInt32`() {
        let value: UInt32 = 0x1234_5678
        let bytes = value.bytes(endianness: .little)

        #expect(bytes.count == 4)
        #expect(bytes == [0x78, 0x56, 0x34, 0x12])
    }

    @Test
    func `bytes with big endian UInt32`() {
        let value: UInt32 = 0x1234_5678
        let bytes = value.bytes(endianness: .big)

        #expect(bytes.count == 4)
        #expect(bytes == [0x12, 0x34, 0x56, 0x78])
    }

    @Test
    func `bytes count matches memory layout`() {
        let value: UInt64 = 0x1234_5678_9ABC_DEF0
        let bytes = value.bytes()

        #expect(bytes.count == MemoryLayout<UInt64>.size)
    }

    @Test
    func `bytes with zero value`() {
        let value: UInt32 = 0
        let bytes = value.bytes(endianness: .big)

        #expect(bytes.allSatisfy { $0 == 0 })
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
    func `bytes works with Int8`() {
        let value: Int8 = -1
        let bytes = value.bytes()

        #expect(bytes.count == 1)
        #expect(bytes[0] == 0xFF)
    }

    @Test
    func `bytes works with Int16`() {
        let value: Int16 = 0x1234
        let bigEndian = value.bytes(endianness: .big)

        #expect(bigEndian.count == 2)
        #expect(bigEndian[0] == 0x12)
        #expect(bigEndian[1] == 0x34)
    }
}
