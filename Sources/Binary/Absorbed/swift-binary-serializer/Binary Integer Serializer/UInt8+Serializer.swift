#if Serializer
public import Byte

extension UInt8 {

    @inlinable
    public static func serializer(endianness: Binary.Endianness) -> Binary.Serializer<UInt8> {
        Binary.Serializer { value, output in
            output.append(Byte(bitPattern: value))
        }
    }
}
#endif
