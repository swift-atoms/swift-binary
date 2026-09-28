#if Base
public import Byte
public import Property

extension Property where Tag == Binary.Base.Encode, Base == Binary.Base.`32` {

    public func callAsFunction(
        _ bytes: borrowing [Byte],
        alphabet: borrowing [Byte],
        pad: Byte? = nil
    ) -> String {
        precondition(alphabet.count == 32, "Base 32 alphabet must contain exactly 32 bytes")
        var out: [Byte] = []
        out.reserveCapacity(((bytes.count + 4) / 5) * 8)
        var buffer: UInt64 = 0
        var bits: Int = 0
        for i in bytes.indices {
            buffer = (buffer << 8) | UInt64(bytes[i].bitPattern)
            bits += 8
            while bits >= 5 {
                bits -= 5
                out.append(alphabet[Int((buffer >> bits) & 0x1F)])
            }
        }
        if bits > 0 {
            out.append(alphabet[Int((buffer << (5 - bits)) & 0x1F)])
        }
        if let p = pad {
            while !out.count.isMultiple(of: 8) { out.append(p) }
        }
        return String(decoding: out.map(\.bitPattern), as: UTF8.self)
    }
}
#endif
