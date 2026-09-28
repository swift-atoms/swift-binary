#if Serializer
import Byte

extension Int32 {

    @inlinable
    public static func serializer(endianness: Binary.Endianness) -> Binary.Serializer<Int32> {
        Binary.Serializer { value, output in
            output.append(contentsOf: [Byte](value, endianness: endianness))
        }
    }
}
#endif
