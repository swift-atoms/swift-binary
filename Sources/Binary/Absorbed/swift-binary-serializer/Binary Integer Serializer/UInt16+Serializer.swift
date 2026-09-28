#if Serializer
import Byte

extension UInt16 {

    @inlinable
    public static func serializer(endianness: Binary.Endianness) -> Binary.Serializer<UInt16> {
        Binary.Serializer { value, output in
            output.append(contentsOf: [Byte](value, endianness: endianness))
        }
    }
}
#endif
