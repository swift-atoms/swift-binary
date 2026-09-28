#if Base
public import Byte
internal import Property

extension Binary.Base.`62` {

    public struct Alphabet: Sendable, Hashable {

        @usableFromInline internal let encodeTable: [Byte]

        @usableFromInline internal let decodeTable: [UInt8]

        public init(_ bytes: [Byte]) {
            precondition(bytes.count == 62, "Base 62 alphabet must contain exactly 62 bytes")

            var inverse = [UInt8](repeating: 0xFF, count: 256)
            for (digit, codeUnit) in bytes.enumerated() {
                precondition(
                    inverse[Int(codeUnit.bitPattern)] == 0xFF,
                    "Base 62 alphabet must contain unique bytes"
                )
                inverse[Int(codeUnit.bitPattern)] = UInt8(digit)
            }

            self.encodeTable = bytes
            self.decodeTable = inverse
        }

        @inlinable
        public func encode(_ value: UInt8) -> Byte {
            encodeTable[Int(value)]
        }

        @inlinable
        public func decode(_ byte: Byte) -> UInt8? {
            let value = decodeTable[Int(byte.bitPattern)]
            return value == 0xFF ? nil : value
        }

        @inlinable
        public func isValid(_ byte: Byte) -> Bool {
            decodeTable[Int(byte.bitPattern)] != 0xFF
        }

        public static let standard: Alphabet = .init(
            Property<Binary.Base.Encode, Binary.Base.`62`>.standardAlphabet
        )

        public static let gmp: Alphabet = .init(
            Property<Binary.Base.Encode, Binary.Base.`62`>.gmpAlphabet
        )

        public static let inverted: Alphabet = .init(
            Property<Binary.Base.Encode, Binary.Base.`62`>.invertedAlphabet
        )

        public static var `default`: Self { .standard }
    }
}
#endif
