#if Cursor
import Difference

/// Only explicitly unchecked movement interprets displacement modulo the native word width.
/// The caller still preconditions that the wrapped result lies within its storage bounds.
@usableFromInline
@inline(__always)
internal func _binaryWrappingOffset(_ offset: Difference) -> Int {
    let magnitude = offset.magnitude.value.rawValue
    let bits = offset.polarity == .negative ? UInt.zero &- magnitude : magnitude
    return Int(bitPattern: bits)
}
#endif
