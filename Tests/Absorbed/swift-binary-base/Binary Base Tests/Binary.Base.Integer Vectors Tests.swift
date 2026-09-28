#if Base
import Binary
import Byte
import Testing

@Suite
struct `Base 58 and 85 preserve integer golden vectors` {
    static let base58 = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
        .utf8.map(Byte.init(bitPattern:))
    static let base85 = (UInt8(33)...UInt8(117)).map(Byte.init(bitPattern:))

    @Test(arguments: [
        (UInt64(0), "1"),
        (UInt64(1), "2"),
        (UInt64(57), "z"),
        (UInt64(58), "21"),
        (UInt64(255), "5Q"),
        (UInt64(123_456_789), "BukQL"),
        (UInt64.max, "jpXCZedGfVQ"),
    ])
    func `Base 58 encodes and decodes known values`(value: UInt64, encoded: String) {
        #expect(Binary.Base.`58`.encode(value, alphabet: Self.base58) == encoded)
        #expect(Binary.Base.`58`.decode(encoded, alphabet: Self.base58) == value)
    }

    @Test(arguments: [
        (UInt64(0), "!"),
        (UInt64(1), "\""),
        (UInt64(84), "u"),
        (UInt64(85), "\"!"),
        (UInt64(255), "$!"),
        (UInt64(123_456_789), "#@#Ff"),
        (UInt64.max, "pW[#knfs9!"),
    ])
    func `Base 85 encodes and decodes known values`(value: UInt64, encoded: String) {
        #expect(Binary.Base.`85`.encode(value, alphabet: Self.base85) == encoded)
        #expect(Binary.Base.`85`.decode(encoded, alphabet: Self.base85) == value)
    }

    @Test
    func `Decoders reject invalid bytes and unsigned overflow`() {
        #expect(Binary.Base.`58`.decode("0", alphabet: Self.base58) == nil)
        #expect(Binary.Base.`85`.decode("v", alphabet: Self.base85) == nil)
        #expect(Binary.Base.`58`.decode("jpXCZedGfVQ1", alphabet: Self.base58) == nil)
        #expect(Binary.Base.`85`.decode("pW[#knfs9!!", alphabet: Self.base85) == nil)
    }
}
#endif
