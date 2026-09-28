#if Byte
import Binary
import Byte
import Testing

@Suite
struct `RangeReplaceableCollection+Bytes Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
    @Suite(.serialized) struct Performance {}
}

extension `RangeReplaceableCollection+Bytes Tests`.Unit {

    @Test
    func `append UTF-8 string to buffer`() {
        var buffer: [Byte] = []
        buffer.append(utf8: "Hello")
        #expect(buffer == [Byte(bitPattern: 72), Byte(bitPattern: 101), Byte(bitPattern: 108), Byte(bitPattern: 108), Byte(bitPattern: 111)])
    }

    @Test
    func `append UTF-8 string static method`() {
        var buffer: [Byte] = []
        [Byte].append(utf8: "World", to: &buffer)
        #expect(buffer == [Byte(bitPattern: 87), Byte(bitPattern: 111), Byte(bitPattern: 114), Byte(bitPattern: 108), Byte(bitPattern: 100)])
    }

    @Test
    func `append UTF-8 to existing content`() {
        var buffer: [Byte] = [Byte(bitPattern: 72), Byte(bitPattern: 105)]
        buffer.append(utf8: " there")
        #expect(String(buffer) == "Hi there")
    }

    @Test
    func `append empty UTF-8 string`() {
        var buffer: [Byte] = [Byte(bitPattern: 1), Byte(bitPattern: 2), Byte(bitPattern: 3)]
        buffer.append(utf8: "")
        #expect(buffer == [Byte(bitPattern: 1), Byte(bitPattern: 2), Byte(bitPattern: 3)])
    }

    @Test
    func `append UTF-8 unicode characters`() {
        var buffer: [Byte] = []
        buffer.append(utf8: "Hello")
        #expect(String(buffer) == "Hello")
    }

    @Test
    func `append single byte to buffer`() {
        var buffer: [Byte] = []
        [Byte].append(Byte(bitPattern: 0x41), to: &buffer)
        #expect(buffer == [Byte(bitPattern: 0x41)])
    }

    @Test
    func `append single byte instance method`() {
        var buffer: [Byte] = []
        buffer.append(Byte(bitPattern: 0x42))
        #expect(buffer == [Byte(bitPattern: 0x42)])
    }

    @Test
    func `append multiple single bytes`() {
        var buffer: [Byte] = []
        buffer.append(Byte(bitPattern: 0x01))
        buffer.append(Byte(bitPattern: 0x02))
        buffer.append(Byte(bitPattern: 0x03))
        #expect(buffer == [Byte(bitPattern: 0x01), Byte(bitPattern: 0x02), Byte(bitPattern: 0x03)])
    }

    @Test
    func `append UTF-8 to ContiguousArray`() {
        var buffer: ContiguousArray<Byte> = []
        buffer.append(utf8: "Test")
        let expected: [Byte] = [Byte(bitPattern: 84), Byte(bitPattern: 101), Byte(bitPattern: 115), Byte(bitPattern: 116)]
        #expect([Byte](buffer) == expected)
    }

    @Test
    func `append byte to ContiguousArray`() {
        var buffer: ContiguousArray<Byte> = []
        buffer.append(Byte(bitPattern: 0xFF))
        let expected: [Byte] = [Byte(bitPattern: 0xFF)]
        #expect([Byte](buffer) == expected)
    }
}
#endif
