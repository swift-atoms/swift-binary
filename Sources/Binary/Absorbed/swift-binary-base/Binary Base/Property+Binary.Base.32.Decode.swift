#if Base
public import Byte
public import Property

extension Property where Tag == Binary.Base.Decode, Base == Binary.Base.`32` {

    public func callAsFunction(
        _ text: borrowing String,
        alphabet: borrowing [Byte],
        pad: Byte? = nil
    ) -> [Byte]? {
        precondition(alphabet.count == 32, "Base 32 alphabet must contain exactly 32 bytes")
        var input = Array(text.utf8)
        if let p = pad {
            while input.last == p.bitPattern { input.removeLast() }
        }

        var inverse: [UInt8] = Array(repeating: 0xFF, count: 256)
        for (digit, codeUnit) in alphabet.enumerated() {
            inverse[Int(codeUnit.bitPattern)] = UInt8(digit)
        }

        var out: [Byte] = []
        out.reserveCapacity((input.count * 5) / 8)
        var buffer: UInt64 = 0
        var bits: Int = 0
        for i in 0..<input.count {
            let value = inverse[Int(input[i])]
            if value == 0xFF { return nil }
            buffer = (buffer << 5) | UInt64(value)
            bits += 5
            if bits >= 8 {
                bits -= 8
                out.append(Byte(bitPattern: UInt8((buffer >> bits) & 0xFF)))
            }
        }
        return out
    }
}
#endif
