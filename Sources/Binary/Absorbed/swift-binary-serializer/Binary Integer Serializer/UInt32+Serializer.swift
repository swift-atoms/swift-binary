#if Serializer
import Byte

extension UInt32 {

    @inlinable
    public static func serializer(endianness: Binary.Endianness) -> Binary.Serializer<UInt32> {
        Binary.Serializer { value, output in
            output.append(contentsOf: [Byte](value, endianness: endianness))
        }
    }
}
#endif
