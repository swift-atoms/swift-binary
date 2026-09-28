#if Serializer
import Byte

extension UInt64 {

    @inlinable
    public static func serializer(endianness: Binary.Endianness) -> Binary.Serializer<UInt64> {
        Binary.Serializer { value, output in
            output.append(contentsOf: [Byte](value, endianness: endianness))
        }
    }
}
#endif
