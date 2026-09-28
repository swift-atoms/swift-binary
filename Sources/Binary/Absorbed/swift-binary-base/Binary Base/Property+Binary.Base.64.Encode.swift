#if Base
public import Byte
public import Property

extension Property where Tag == Binary.Base.Encode, Base == Binary.Base.`64` {

    public func callAsFunction(
        _ bytes: borrowing [Byte],
        alphabet: borrowing [Byte],
        pad: Byte? = nil
    ) -> String {
        precondition(alphabet.count == 64, "Base 64 alphabet must contain exactly 64 bytes")
        var out: [Byte] = []
        out.reserveCapacity(((bytes.count + 2) / 3) * 4)
        var i = 0
        while i + 3 <= bytes.count {
            let a = bytes[i].bitPattern
            let b = bytes[i + 1].bitPattern
            let c = bytes[i + 2].bitPattern
            out.append(alphabet[Int(a >> 2)])
            out.append(alphabet[Int(((a & 0x03) << 4) | (b >> 4))])
            out.append(alphabet[Int(((b & 0x0F) << 2) | (c >> 6))])
            out.append(alphabet[Int(c & 0x3F)])
            i += 3
        }
        let leftover = bytes.count - i
        if leftover == 1 {
            let a = bytes[i].bitPattern
            out.append(alphabet[Int(a >> 2)])
            out.append(alphabet[Int((a & 0x03) << 4)])
            if let p = pad {
                out.append(p)
                out.append(p)
            }
        } else if leftover == 2 {
            let a = bytes[i].bitPattern
            let b = bytes[i + 1].bitPattern
            out.append(alphabet[Int(a >> 2)])
            out.append(alphabet[Int(((a & 0x03) << 4) | (b >> 4))])
            out.append(alphabet[Int((b & 0x0F) << 2)])
            if let p = pad { out.append(p) }
        }
        return String(decoding: out.map(\.bitPattern), as: UTF8.self)
    }
}
#endif
