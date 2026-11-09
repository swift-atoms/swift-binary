public import Byte

#if Byte
    public import Byte

    extension RangeReplaceableCollection<Byte> {

        @inlinable

        public static func append<S: StringProtocol, Buffer: RangeReplaceableCollection>(
            utf8 string: S,
            to buffer: inout Buffer
        ) where Buffer.Element == Byte {
            buffer.append(contentsOf: string.utf8.lazy.map(Byte.init(bitPattern:)))
        }

        @inlinable
        public mutating func append(utf8 string: some StringProtocol) {
            Self.append(utf8: string, to: &self)
        }

        @inlinable

        public static func append<Buffer: RangeReplaceableCollection>(
            _ value: Byte,
            to buffer: inout Buffer
        ) where Buffer.Element == Byte {
            buffer.append(contentsOf: CollectionOfOne(value))
        }
    }
#endif

extension RangeReplaceableCollection<Byte> {

    @inlinable
    public init(_ value: some FixedWidthInteger, endianness: Binary.Endianness) {
        self.init(integer: value, endianness: endianness)
    }

    @inlinable
    @_disfavoredOverload
    public init(_ value: UInt8, endianness: Binary.Endianness = .little) {
        self.init(integer: value, endianness: endianness)
    }

    @inlinable
    public init(_ value: Int8, endianness: Binary.Endianness = .little) {
        self.init(integer: value, endianness: endianness)
    }

    @inlinable
    public init(_ value: UInt16, endianness: Binary.Endianness = .little) {
        self.init(integer: value, endianness: endianness)
    }

    @inlinable
    public init(_ value: Int16, endianness: Binary.Endianness = .little) {
        self.init(integer: value, endianness: endianness)
    }

    @inlinable
    public init(_ value: UInt32, endianness: Binary.Endianness = .little) {
        self.init(integer: value, endianness: endianness)
    }

    @inlinable
    public init(_ value: Int32, endianness: Binary.Endianness = .little) {
        self.init(integer: value, endianness: endianness)
    }

    @inlinable
    public init(_ value: UInt64, endianness: Binary.Endianness = .little) {
        self.init(integer: value, endianness: endianness)
    }

    @inlinable
    public init(_ value: Int64, endianness: Binary.Endianness = .little) {
        self.init(integer: value, endianness: endianness)
    }

    @usableFromInline
    internal init(integer value: some FixedWidthInteger, endianness: Binary.Endianness) {
        self.init()
        reserveCapacity(MemoryLayout.size(ofValue: value))
        value.bytes(into: &self, endianness: endianness)
    }

    @inlinable
    public init<Values: Swift::Collection>(
        serializing values: Values,
        endianness: Binary.Endianness = .little
    ) where Values.Element: FixedWidthInteger {
        self.init()
        reserveCapacity(values.count * MemoryLayout<Values.Element>.size)
        for value in values {
            value.bytes(into: &self, endianness: endianness)
        }
    }

    @inlinable
    public mutating func append(_ value: some FixedWidthInteger, endianness: Binary.Endianness) {
        value.bytes(into: &self, endianness: endianness)
    }

    @inlinable
    @_disfavoredOverload
    public mutating func append(_ value: UInt8, endianness: Binary.Endianness = .little) {
        value.bytes(into: &self, endianness: endianness)
    }

    @inlinable
    public mutating func append(_ value: Int8, endianness: Binary.Endianness = .little) {
        value.bytes(into: &self, endianness: endianness)
    }

    @inlinable
    public mutating func append(_ value: UInt16, endianness: Binary.Endianness = .little) {
        value.bytes(into: &self, endianness: endianness)
    }

    @inlinable
    public mutating func append(_ value: Int16, endianness: Binary.Endianness = .little) {
        value.bytes(into: &self, endianness: endianness)
    }

    @inlinable
    public mutating func append(_ value: UInt32, endianness: Binary.Endianness = .little) {
        value.bytes(into: &self, endianness: endianness)
    }

    @inlinable
    public mutating func append(_ value: Int32, endianness: Binary.Endianness = .little) {
        value.bytes(into: &self, endianness: endianness)
    }

    @inlinable
    public mutating func append(_ value: UInt64, endianness: Binary.Endianness = .little) {
        value.bytes(into: &self, endianness: endianness)
    }

    @inlinable
    public mutating func append(_ value: Int64, endianness: Binary.Endianness = .little) {
        value.bytes(into: &self, endianness: endianness)
    }
}
