#if Base
public import Byte
import Byte
public import Property

extension Property where Tag == Binary.Base.Encode, Base == Binary.Base.`85` {

    public func callAsFunction(
        _ value: UInt64,
        alphabet: borrowing [Byte]
    ) -> String {
        precondition(alphabet.count == 85, "Base 85 alphabet must contain exactly 85 bytes")
        if value == 0 { return String(decoding: [alphabet[0]], as: UTF8.self) }
        var v = value
        var out: [Byte] = []
        while v > 0 {
            out.append(alphabet[Int(v % 85)])
            v /= 85
        }
        out.reverse()
        return String(decoding: out, as: UTF8.self)
    }
}
#endif
