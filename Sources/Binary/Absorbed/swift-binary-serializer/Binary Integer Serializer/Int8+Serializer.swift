#if Serializer
public import Byte

extension Int8 {

    @inlinable
    public static func serializer(endianness: Binary.Endianness) -> Binary.Serializer<Int8> {
        Binary.Serializer { value, output in
            output.append(Byte(bitPattern: UInt8(bitPattern: value)))
        }
    }
}
#endif
