#if Base
public import Byte
import Byte
public import Property

extension Property where Tag == Binary.Base.Encode, Base == Binary.Base.`62` {

    public func callAsFunction(
        _ value: UInt64,
        alphabet: borrowing [Byte]
    ) -> String {
        precondition(alphabet.count == 62, "Base 62 alphabet must contain exactly 62 bytes")
        if value == 0 { return String(decoding: [alphabet[0]], as: UTF8.self) }
        var v = value
        var out: [Byte] = []
        while v > 0 {
            out.append(alphabet[Int(v % 62)])
            v /= 62
        }
        out.reverse()
        return String(decoding: out, as: UTF8.self)
    }

    public func callAsFunction(_ value: UInt64) -> String {
        callAsFunction(value, alphabet: Self.standardAlphabet)
    }

    public func gmp(_ value: UInt64) -> String {
        callAsFunction(value, alphabet: Self.gmpAlphabet)
    }

    public func inverted(_ value: UInt64) -> String {
        callAsFunction(value, alphabet: Self.invertedAlphabet)
    }

    public static var standardAlphabet: [Byte] {
        "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz".utf8.map(Byte.init(bitPattern:))
    }

    public static var gmpAlphabet: [Byte] {
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789".utf8.map(Byte.init(bitPattern:))
    }

    public static var invertedAlphabet: [Byte] {
        "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".utf8.map(Byte.init(bitPattern:))
    }
}
#endif
