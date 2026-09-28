#if LEB128
import Binary
import Binary_LEB128_Parser_Test_Support
import Byte
import Testing

@Suite
struct `Binary.LEB128.Unsigned Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension `Binary.LEB128.Unsigned Tests`.Unit {

    @Test
    func `parse single byte value`() throws {
        let parser = Binary.LEB128.Unsigned<UInt64>()
        var input = bytes(0x00)

        let value = try parser.parse(&input)

        #expect(value == 0)
        #expect(input.isEmpty)
    }

    @Test
    func `parse single byte max value`() throws {
        let parser = Binary.LEB128.Unsigned<UInt64>()
        var input = bytes(0x7F)

        let value = try parser.parse(&input)

        #expect(value == 127)
    }

    @Test
    func `parse two byte value`() throws {
        let parser = Binary.LEB128.Unsigned<UInt64>()
        var input = bytes(0x80, 0x01)

        let value = try parser.parse(&input)

        #expect(value == 128)
    }

    @Test
    func `parse known value 624485`() throws {

        let parser = Binary.LEB128.Unsigned<UInt64>()
        var input = bytes(0xE5, 0x8E, 0x26)

        let value = try parser.parse(&input)

        #expect(value == 624485)
    }

    @Test
    func `parse consumes only needed bytes`() throws {
        let parser = Binary.LEB128.Unsigned<UInt64>()
        var input = bytes(0x7F, 0xAA, 0xBB)

        let value = try parser.parse(&input)

        #expect(value == 127)
        #expect(input.count == 2)
    }

    @Test
    func `parse UInt8 max value`() throws {
        let parser = Binary.LEB128.Unsigned<UInt8>()
        var input = bytes(0xFF, 0x01)

        let value = try parser.parse(&input)

        #expect(value == 255)
    }

    @Test
    func `parse UInt16 max value`() throws {
        let parser = Binary.LEB128.Unsigned<UInt16>()
        var input = bytes(0xFF, 0xFF, 0x03)

        let value = try parser.parse(&input)

        #expect(value == 65535)
    }
}

extension `Binary.LEB128.Unsigned Tests`.`Edge Case` {

    @Test
    func `parse empty input throws unterminated`() {
        let parser = Binary.LEB128.Unsigned<UInt64>()
        var input = bytes()

        #expect(throws: Binary.LEB128.Error.self) {
            try parser.parse(&input)
        }
    }

    @Test
    func `parse unterminated sequence throws`() {
        let parser = Binary.LEB128.Unsigned<UInt64>()
        var input = bytes(0x80)

        #expect(throws: Binary.LEB128.Error.self) {
            try parser.parse(&input)
        }
    }

    @Test
    func `parse overflow throws for UInt8`() {
        let parser = Binary.LEB128.Unsigned<UInt8>()
        var input = bytes(0x80, 0x02)

        #expect(throws: Binary.LEB128.Error.self) {
            try parser.parse(&input)
        }
    }

    @Test
    func `parse zero`() throws {
        let parser = Binary.LEB128.Unsigned<UInt64>()
        var input = bytes(0x00)

        let value = try parser.parse(&input)

        #expect(value == 0)
    }
}

@Suite
struct `Binary.LEB128.Signed Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension `Binary.LEB128.Signed Tests`.Unit {

    @Test
    func `parse zero`() throws {
        let parser = Binary.LEB128.Signed<Int64>()
        var input = bytes(0x00)

        let value = try parser.parse(&input)

        #expect(value == 0)
    }

    @Test
    func `parse positive single byte`() throws {
        let parser = Binary.LEB128.Signed<Int64>()
        var input = bytes(0x3F)

        let value = try parser.parse(&input)

        #expect(value == 63)
    }

    @Test
    func `parse negative one`() throws {
        let parser = Binary.LEB128.Signed<Int64>()
        var input = bytes(0x7F)

        let value = try parser.parse(&input)

        #expect(value == -1)
    }

    @Test
    func `parse negative two`() throws {
        let parser = Binary.LEB128.Signed<Int64>()
        var input = bytes(0x7E)

        let value = try parser.parse(&input)

        #expect(value == -2)
    }

    @Test
    func `parse positive two byte value`() throws {
        let parser = Binary.LEB128.Signed<Int64>()
        var input = bytes(0x80, 0x01)

        let value = try parser.parse(&input)

        #expect(value == 128)
    }

    @Test
    func `parse negative 128`() throws {
        let parser = Binary.LEB128.Signed<Int64>()
        var input = bytes(0x80, 0x7F)

        let value = try parser.parse(&input)

        #expect(value == -128)
    }

    @Test
    func `parse consumes only needed bytes`() throws {
        let parser = Binary.LEB128.Signed<Int64>()
        var input = bytes(0x00, 0xFF, 0xFF)

        let value = try parser.parse(&input)

        #expect(value == 0)
        #expect(input.count == 2)
    }
}

extension `Binary.LEB128.Signed Tests`.`Edge Case` {

    @Test
    func `parse empty input throws unterminated`() {
        let parser = Binary.LEB128.Signed<Int64>()
        var input = bytes()

        #expect(throws: Binary.LEB128.Error.self) {
            try parser.parse(&input)
        }
    }

    @Test
    func `parse unterminated sequence throws`() {
        let parser = Binary.LEB128.Signed<Int64>()
        var input = bytes(0x80)

        #expect(throws: Binary.LEB128.Error.self) {
            try parser.parse(&input)
        }
    }

    @Test
    func `parse Int8 min value`() throws {
        let parser = Binary.LEB128.Signed<Int8>()
        var input = bytes(0x80, 0x7F)

        let value = try parser.parse(&input)

        #expect(value == -128)
    }

    @Test
    func `parse Int8 max value`() throws {
        let parser = Binary.LEB128.Signed<Int8>()
        var input = bytes(0xFF, 0x00)

        let value = try parser.parse(&input)

        #expect(value == 127)
    }
}


extension `Binary.LEB128.Unsigned Tests`.Integration {
    @Test func redundantEncodingAndNonzeroSlicePreserveRemainder() throws {
        let storage = Array(bytes(0xFF, 0x83, 0x00, 0xAA))
        var input = storage.dropFirst()
        #expect(try Binary.LEB128.Unsigned<UInt8>().parse(&input) == 3)
        #expect(input.startIndex == 3)
        #expect(input.map(\.bitPattern) == [0xAA])
    }

    @Test func overflowConsumesRejectedByteButPreservesRemainder() {
        var input = bytes(0x80, 0x80, 0x00, 0xAA)
        #expect(throws: Binary.LEB128.Error.overflow(bitWidth: 8)) {
            try Binary.LEB128.Unsigned<UInt8>().parse(&input)
        }
        #expect(input.map(\.bitPattern) == [0x00, 0xAA])
    }
}

extension `Binary.LEB128.Signed Tests`.Integration {
    @Test func redundantSignExtensionPreservesRemainder() throws {
        var input = bytes(0xFE, 0xFF, 0x7F, 0xAA)
        #expect(try Binary.LEB128.Signed<Int16>().parse(&input) == -2)
        #expect(input.map(\.bitPattern) == [0xAA])
    }

    @Test func invalidSignBitsConsumeRejectedByte() {
        var input = bytes(0x80, 0x01, 0xAA)
        #expect(throws: Binary.LEB128.Error.overflow(bitWidth: 8)) {
            try Binary.LEB128.Signed<Int8>().parse(&input)
        }
        #expect(input.map(\.bitPattern) == [0xAA])
    }
}

private func bytes(_ patterns: UInt8...) -> ArraySlice<Byte> {
    patterns.map(Byte.init(bitPattern:))[...]
}
#endif
