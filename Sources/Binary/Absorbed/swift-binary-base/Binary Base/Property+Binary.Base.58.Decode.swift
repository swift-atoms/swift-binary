#if Base
public import Byte
public import Property

extension Property where Tag == Binary.Base.Decode, Base == Binary.Base.`58` {

    public func callAsFunction(
        _ text: borrowing String,
        alphabet: borrowing [Byte]
    ) -> UInt64? {
        precondition(alphabet.count == 58, "Base 58 alphabet must contain exactly 58 bytes")
        var inverse: [UInt8] = Array(repeating: 0xFF, count: 256)
        for (digit, codeUnit) in alphabet.enumerated() {
            inverse[Int(codeUnit.bitPattern)] = UInt8(digit)
        }

        var result: UInt64 = 0
        for codeUnit in text.utf8 {
            let digit = inverse[Int(codeUnit)]
            if digit == 0xFF { return nil }
            let (mul, mulOverflow) = result.multipliedReportingOverflow(by: 58)
            if mulOverflow { return nil }
            let (add, addOverflow) = mul.addingReportingOverflow(UInt64(digit))
            if addOverflow { return nil }
            result = add
        }
        return result
    }
}
#endif
