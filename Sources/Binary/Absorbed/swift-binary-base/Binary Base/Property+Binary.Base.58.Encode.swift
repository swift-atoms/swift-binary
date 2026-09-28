#if Base
public import Byte
import Byte
public import Property

extension Property where Tag == Binary.Base.Encode, Base == Binary.Base.`58` {

    public func callAsFunction(
        _ value: UInt64,
        alphabet: borrowing [Byte]
    ) -> String {
        precondition(alphabet.count == 58, "Base 58 alphabet must contain exactly 58 bytes")
        if value == 0 { return String(decoding: [alphabet[0]], as: UTF8.self) }
        var v = value
        var out: [Byte] = []
        while v > 0 {
            out.append(alphabet[Int(v % 58)])
            v /= 58
        }
        out.reverse()
        return String(decoding: out, as: UTF8.self)
    }
}
#endif
