#if LEB128
extension Binary.LEB128 {

    public struct Signed<T: SignedInteger & FixedWidthInteger>: Sendable {

        @inlinable
        public init() {}
    }
}

extension Binary.LEB128.Signed: Parsing {

    public typealias Input = ArraySlice<Byte>

    public typealias Output = T

    public typealias Failure = Binary.LEB128.Error

    public typealias Body = Never

    @inlinable
    public func parse(_ input: inout Input) throws(Failure) -> T {
        var result: T = 0
        var shift: Int = 0
        while true {
            guard let byte = input.first else {
                throw .unterminated
            }
            input.removeFirst()

            if try Binary.LEB128.Decode.signed(
                byte: byte.bitPattern,
                into: &result,
                shift: &shift
            ) {
                return result
            }
        }
    }
}
#endif
