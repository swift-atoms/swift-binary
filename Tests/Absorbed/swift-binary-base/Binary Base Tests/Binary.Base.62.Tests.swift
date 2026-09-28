#if Base
import Binary
import Binary_Base_Test_Support
import Byte
import Testing

@Suite
struct `Base 62 preserves integer values` {
    @Test
    func `Standard alphabet round-trips UInt64`() {
        let encoded = Binary.Base.`62`.encode(UInt64(123_456_789))
        #expect(encoded == "8M0kX")

        let decoded = Binary.Base.`62`.decode(encoded)
        #expect(decoded == 123_456_789)
    }

    @Test
    func `Standard alphabet encodes zero as alphabet[0]`() {
        let encoded = Binary.Base.`62`.encode(UInt64(0))
        #expect(encoded == "0")
    }

    @Test
    func `Gmp variant encodes value differently from standard`() {
        let standard = Binary.Base.`62`.encode(UInt64(123_456_789))
        let gmp = Binary.Base.`62`.encode.gmp(UInt64(123_456_789))
        #expect(standard != gmp)
        #expect(gmp == "IWAuh")

        let decoded = Binary.Base.`62`.decode.gmp(gmp)
        #expect(decoded == 123_456_789)
    }

    @Test
    func `Inverted variant round-trips`() {
        let value = UInt64(987_654_321)
        let encoded = Binary.Base.`62`.encode.inverted(value)
        let decoded = Binary.Base.`62`.decode.inverted(encoded)
        #expect(decoded == value)
    }

    @Test
    func `Decode rejects invalid character`() {
        let result = Binary.Base.`62`.decode("8M0!X")
        #expect(result == nil)
    }

    @Test
    func `Custom alphabet path works`() {
        let alphabet = "ZYXWVUTSRQPONMLKJIHGFEDCBAzyxwvutsrqponmlkjihgfedcba9876543210".utf8.map(
            Byte.init(bitPattern:)
        )
        let encoded = Binary.Base.`62`.encode(UInt64(42), alphabet: alphabet)
        let decoded = Binary.Base.`62`.decode(encoded, alphabet: alphabet)
        #expect(decoded == 42)
    }

    @Test
    func `Decode.digit reads per-byte against standard alphabet`() {
        #expect(Binary.Base.`62`.decode.digit(Byte(bitPattern: UInt8(ascii: "A"))) == 10)
        #expect(Binary.Base.`62`.decode.digit(Byte(bitPattern: UInt8(ascii: "a"))) == 36)
        #expect(Binary.Base.`62`.decode.digit(Byte(bitPattern: UInt8(ascii: "!"))) == nil)
    }

    @Test
    func `Decode.digit honours alphabet parameter`() {
        #expect(Binary.Base.`62`.decode.digit(Byte(bitPattern: UInt8(ascii: "A")), alphabet: .gmp) == 0)
    }

    @Test
    func `Decode.isValid mirrors digit non-nil-ness`() {
        #expect(Binary.Base.`62`.decode.isValid(Byte(bitPattern: UInt8(ascii: "Z"))) == true)
        #expect(Binary.Base.`62`.decode.isValid(Byte(bitPattern: UInt8(ascii: " "))) == false)
    }
}
#endif
