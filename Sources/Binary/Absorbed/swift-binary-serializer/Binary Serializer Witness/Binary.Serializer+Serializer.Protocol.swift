#if Serializer
public import Byte
public import Serializer

extension Binary.Serializer: Serializing {
    public var body: Never {
        borrowing get {
            return fatalError("\(Self.self) is a leaf coder: implement parse and serialize directly")
        }
    }


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
