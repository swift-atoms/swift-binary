#if Base
public import Byte
public import Property

extension Property where Tag == Binary.Base.Decode, Base == Binary.Base.`62` {

    public func callAsFunction(
        _ text: borrowing String,
        alphabet: Binary.Base.`62`.Alphabet
    ) -> UInt64? {
        var result: UInt64 = 0
        for codeUnit in text.utf8 {
            guard let digit = alphabet.decode(Byte(bitPattern: codeUnit)) else { return nil }
            let (mul, mulOverflow) = result.multipliedReportingOverflow(by: 62)
            if mulOverflow { return nil }
            let (add, addOverflow) = mul.addingReportingOverflow(UInt64(digit))
            if addOverflow { return nil }
            result = add
        }
        return result
    }

    public func callAsFunction(
        _ text: borrowing String,
        alphabet: [Byte]
    ) -> UInt64? {
        callAsFunction(text, alphabet: Binary.Base.`62`.Alphabet(alphabet))
    }

    public func callAsFunction(_ text: borrowing String) -> UInt64? {
        callAsFunction(text, alphabet: Binary.Base.`62`.Alphabet.standard)
    }

    public func gmp(_ text: borrowing String) -> UInt64? {
        callAsFunction(text, alphabet: Binary.Base.`62`.Alphabet.gmp)
    }

    public func inverted(_ text: borrowing String) -> UInt64? {
        callAsFunction(text, alphabet: Binary.Base.`62`.Alphabet.inverted)
    }

    @inlinable
    public func digit(_ byte: Byte) -> UInt8? {
        Binary.Base.`62`.Alphabet.standard.decode(byte)
    }

    @inlinable
    public func digit(_ byte: Byte, alphabet: Binary.Base.`62`.Alphabet) -> UInt8? {
        alphabet.decode(byte)
    }

    @inlinable
    public func isValid(_ byte: Byte) -> Bool {
        Binary.Base.`62`.Alphabet.standard.isValid(byte)
    }

    @inlinable
    public func isValid(_ byte: Byte, alphabet: Binary.Base.`62`.Alphabet) -> Bool {
        alphabet.isValid(byte)
    }
}
#endif
