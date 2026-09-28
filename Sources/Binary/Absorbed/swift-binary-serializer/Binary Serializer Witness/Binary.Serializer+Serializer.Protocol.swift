#if Serializer
public import Byte
public import Serializer

extension Binary.Serializer: Serializing {

    public typealias Output = Value

    public typealias Buffer = [Byte]

    public typealias Failure = Never

    public typealias Body = Never

    @inlinable
    public borrowing func serialize(_ output: Value, into buffer: inout [Byte]) {
        _serialize(output, &buffer)
    }
}
#endif
