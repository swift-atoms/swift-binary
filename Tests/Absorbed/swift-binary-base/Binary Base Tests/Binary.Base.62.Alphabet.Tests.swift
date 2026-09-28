#if Base
import Binary
import Binary_Base_Test_Support
import Byte
import Testing

@Suite
struct `Base 62 alphabets map byte values` {
    @Test
    func `Standard alphabet decodes digit 0–9 to value 0–9`() {
        let alphabet = Binary.Base.`62`.Alphabet.standard
        #expect(alphabet.decode(Byte(bitPattern: UInt8(ascii: "0"))) == 0)
        #expect(alphabet.decode(Byte(bitPattern: UInt8(ascii: "9"))) == 9)
    }

    @Test
    func `Standard alphabet decodes uppercase A–Z to 10–35`() {
        let alphabet = Binary.Base.`62`.Alphabet.standard
        #expect(alphabet.decode(Byte(bitPattern: UInt8(ascii: "A"))) == 10)
        #expect(alphabet.decode(Byte(bitPattern: UInt8(ascii: "Z"))) == 35)
    }

    @Test
    func `Standard alphabet decodes lowercase a–z to 36–61`() {
        let alphabet = Binary.Base.`62`.Alphabet.standard
        #expect(alphabet.decode(Byte(bitPattern: UInt8(ascii: "a"))) == 36)
        #expect(alphabet.decode(Byte(bitPattern: UInt8(ascii: "z"))) == 61)
    }

    @Test
    func `Decode returns nil for bytes outside the alphabet`() {
        let alphabet = Binary.Base.`62`.Alphabet.standard
        #expect(alphabet.decode(Byte(bitPattern: UInt8(ascii: "!"))) == nil)
        #expect(alphabet.decode(Byte(bitPattern: UInt8(ascii: " "))) == nil)
        #expect(alphabet.decode(Byte(bitPattern: 0xFF)) == nil)
    }

    @Test
    func `IsValid mirrors decode != nil`() {
        let alphabet = Binary.Base.`62`.Alphabet.standard
        #expect(alphabet.isValid(Byte(bitPattern: UInt8(ascii: "A"))) == true)
        #expect(alphabet.isValid(Byte(bitPattern: UInt8(ascii: "!"))) == false)
    }

    @Test
    func `Encode round-trips with decode for every digit`() {
        let alphabet = Binary.Base.`62`.Alphabet.standard
        for value: UInt8 in 0..<62 {
            let byte = alphabet.encode(value)
            #expect(alphabet.decode(byte) == value)
        }
    }

    @Test
    func `Gmp alphabet differs from standard`() {
        let standard = Binary.Base.`62`.Alphabet.standard
        let gmp = Binary.Base.`62`.Alphabet.gmp

        #expect(standard.decode(Byte(bitPattern: UInt8(ascii: "A"))) == 10)
        #expect(gmp.decode(Byte(bitPattern: UInt8(ascii: "A"))) == 0)
        #expect(gmp.decode(Byte(bitPattern: UInt8(ascii: "0"))) == 52)
    }

    @Test
    func `Inverted alphabet differs from standard`() {
        let inverted = Binary.Base.`62`.Alphabet.inverted

        #expect(inverted.decode(Byte(bitPattern: UInt8(ascii: "a"))) == 10)
        #expect(inverted.decode(Byte(bitPattern: UInt8(ascii: "A"))) == 36)
    }

    @Test
    func `Default alphabet is standard`() {
        #expect(Binary.Base.`62`.Alphabet.default == Binary.Base.`62`.Alphabet.standard)
    }

    @Test
    func `Custom alphabet round-trips`() {
        let bytes = "ZYXWVUTSRQPONMLKJIHGFEDCBAzyxwvutsrqponmlkjihgfedcba9876543210".utf8.map(
            Byte.init(bitPattern:)
        )
        let alphabet = Binary.Base.`62`.Alphabet(bytes)

        #expect(alphabet.decode(Byte(bitPattern: UInt8(ascii: "Z"))) == 0)
        #expect(alphabet.decode(Byte(bitPattern: UInt8(ascii: "0"))) == 61)
        #expect(alphabet.decode(Byte(bitPattern: UInt8(ascii: "?"))) == nil)

        for value: UInt8 in 0..<62 {
            #expect(alphabet.decode(alphabet.encode(value)) == value)
        }
    }

    @Test
    func `Hashable equality holds for same alphabet`() {
        let a = Binary.Base.`62`.Alphabet.standard
        let b = Binary.Base.`62`.Alphabet(
            "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz".utf8.map(Byte.init(bitPattern:))
        )
        #expect(a == b)
        #expect(a.hashValue == b.hashValue)
    }
}
#endif
