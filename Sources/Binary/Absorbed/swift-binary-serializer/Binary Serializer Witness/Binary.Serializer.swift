#if Serializer
public import Byte
public import Witness

extension Binary {

    public struct Serializer<Value>: Witness.`Protocol` {
        @usableFromInline
        let _serialize: (Value, inout [Byte]) -> Void

        @inlinable
        public init(
            serialize: @escaping (Value, inout [Byte]) -> Void
        ) {
            self._serialize = serialize
        }
    }
}

extension Binary.Serializer {

    @inlinable
    public func serializeToArray(_ value: Value) -> [Byte] {
        var out: [Byte] = []
        _serialize(value, &out)
        return out
    }

    @inlinable
    public func serializeAppending(_ value: Value, to buffer: inout [Byte]) {
        _serialize(value, &buffer)
    }
}
#endif
