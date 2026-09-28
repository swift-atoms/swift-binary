#if Base
public import Byte
public import Property

extension Property where Tag == Binary.Base.Decode, Base == Binary.Base.`16` {

    public func callAsFunction(
        _ text: borrowing String,
        alphabet: borrowing [Byte]
    ) -> [Byte]? {
        precondition(alphabet.count == 16, "Base 16 alphabet must contain exactly 16 bytes")
        let textBytes = Array(text.utf8)
        guard textBytes.count.isMultiple(of: 2) else { return nil }

        var inverse: [UInt8] = Array(repeating: 0xFF, count: 256)
        for (digit, codeUnit) in alphabet.enumerated() {
            inverse[Int(codeUnit.bitPattern)] = UInt8(digit)
        }

        var out: [Byte] = []
        out.reserveCapacity(textBytes.count / 2)
        var i = 0
        while i < textBytes.count {
            let high = inverse[Int(textBytes[i])]
            let low = inverse[Int(textBytes[i + 1])]
            if high == 0xFF || low == 0xFF { return nil }
            out.append(Byte(bitPattern: (high << 4) | low))
            i += 2
        }
        return out
    }
}
#endif
