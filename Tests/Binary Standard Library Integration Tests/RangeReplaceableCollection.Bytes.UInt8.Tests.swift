import Binary
import Binary_Standard_Library_Integration
import Testing

@Suite
struct `RangeReplaceableCollection+Bytes UInt8 forwarder Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}

    @Test
    func `append UTF-8 string to [UInt8] buffer`() {
        var buffer: [UInt8] = []
        buffer.append(utf8: "Hello")
        #expect(buffer == [72, 101, 108, 108, 111])
    }

    @Test
    func `append UTF-8 string static method on [UInt8]`() {
        var buffer: [UInt8] = []
        [UInt8].append(utf8: "World", to: &buffer)
        #expect(buffer == [87, 111, 114, 108, 100])
    }

    @Test
    func `append UTF-8 to existing [UInt8] content`() {
        var buffer: [UInt8] = [72, 105]
        buffer.append(utf8: " there")
        #expect(String(decoding: buffer, as: UTF8.self) == "Hi there")
    }

    @Test
    func `append empty UTF-8 to [UInt8] buffer`() {
        var buffer: [UInt8] = [1, 2, 3]
        buffer.append(utf8: "")
        #expect(buffer == [1, 2, 3])
    }

    @Test
    func `append single byte to [UInt8] buffer`() {
        var buffer: [UInt8] = []
        [UInt8].append(0x41, to: &buffer)
        #expect(buffer == [0x41])
    }

    @Test
    func `append UTF-8 to ContiguousArray<UInt8>`() {
        var buffer: ContiguousArray<UInt8> = []
        buffer.append(utf8: "Test")
        #expect(Array(buffer) == [84, 101, 115, 116])
    }
}
