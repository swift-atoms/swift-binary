#if Cursor
import Difference

@usableFromInline
@inline(__always)
internal func _binaryWrappingOffset(_ offset: Difference) -> Int {
    let magnitude = offset.magnitude.value.rawValue
    let bits = offset.polarity == .negative ? UInt.zero &- magnitude : magnitude
    return Int(bitPattern: bits)
}
#endif
