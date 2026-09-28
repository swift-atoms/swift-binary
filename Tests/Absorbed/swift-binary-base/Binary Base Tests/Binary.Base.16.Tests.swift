#if Base
import Binary
import Binary_Base_Test_Support
import Byte
import Testing

@Suite
struct `Base 16 preserves byte values` {

    static let hexAlphabet: [Byte] = "0123456789ABCDEF".utf8.map(Byte.init(bitPattern:))

    @Test
    func `Hex round-trip on DEAD BE EF`() {
        let bytes = ([0xDE, 0xAD, 0xBE, 0xEF] as [UInt8]).map(Byte.init(bitPattern:))
        let encoded = Binary.Base.`16`.encode(bytes, alphabet: Self.hexAlphabet)
        #expect(encoded == "DEADBEEF")

        let decoded = Binary.Base.`16`.decode(encoded, alphabet: Self.hexAlphabet)
        #expect(decoded == bytes)
    }

    @Test
    func `Decode rejects odd-length input`() {
        let result = Binary.Base.`16`.decode("ABC", alphabet: Self.hexAlphabet)
        #expect(result == nil)
    }

    @Test
    func `Decode rejects invalid character`() {
        let result = Binary.Base.`16`.decode("DE!F", alphabet: Self.hexAlphabet)
        #expect(result == nil)
    }

    @Test
    func `Empty bytes encode to empty string`() {
        let encoded = Binary.Base.`16`.encode([] as [Byte], alphabet: Self.hexAlphabet)
        #expect(encoded.isEmpty)
    }
}
#endif
