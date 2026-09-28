#if Serializer
import Byte

extension Int16 {

    @inlinable
    public static func serializer(endianness: Binary.Endianness) -> Binary.Serializer<Int16> {
        Binary.Serializer { value, output in
            output.append(contentsOf: [Byte](value, endianness: endianness))
        }
    }
}
#endif
