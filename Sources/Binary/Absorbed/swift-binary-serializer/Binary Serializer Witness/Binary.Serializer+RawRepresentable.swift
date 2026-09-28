#if Serializer
public import Byte
internal import Byte
public import Serializer

extension Binary.Serializer where Value: RawRepresentable, Value.RawValue: StringProtocol {

    public static var rawValue: Binary.Serializer<Value> {
        Binary.Serializer { value, buffer in

            let raw = value.rawValue
            buffer.append(contentsOf: raw.utf8.lazy.map(Byte.init(bitPattern:)))
        }
    }
}

extension Binary.Serializer where Value: RawRepresentable, Value.RawValue == [Byte] {

    public static var rawValue: Binary.Serializer<Value> {
        Binary.Serializer { value, buffer in

            buffer.append(contentsOf: value.rawValue)
        }
    }
}

extension Binary.Serializer where Value: RawRepresentable, Value.RawValue == [UInt8] {

    public static var rawValue: Binary.Serializer<Value> {
        Binary.Serializer { value, buffer in

            buffer.append(contentsOf: value.rawValue.lazy.map(Byte.init(bitPattern:)))
        }
    }
}

extension Binary.Serializer where Value: RawRepresentable, Value.RawValue: FixedWidthInteger {
    public static func rawValue(endianness: Binary.Endianness) -> Binary.Serializer<Value> {
        Binary.Serializer { value, buffer in
            buffer.append(contentsOf: [Byte](value.rawValue, endianness: endianness))
        }
    }
}
#endif
