#if Cursor
public import Byte
public import Cardinal
public import Difference
public import Ordinal
public import Span

extension Binary {

    public struct Reader<Storage: Span::__Span.`Protocol` & ~Copyable & ~Escapable>: ~Copyable, ~Escapable
    where Storage.Element == Byte {

        public let storage: Storage

        @usableFromInline
        internal let _count: Cardinal

        @usableFromInline
        internal var _readerIndex: Ordinal

        @inlinable
        @_lifetime(copy storage)
        public init(storage: consuming Storage) {
            let byteCount = storage.span.count
            self.storage = storage
            self._count = Cardinal(UInt(byteCount))
            self._readerIndex = .zero
        }
    }
}

extension Binary.Reader where Storage: ~Copyable & ~Escapable {

    public var readerIndex: Ordinal {
        _readerIndex
    }

    public var count: Cardinal {
        _count
    }
}

extension Binary.Reader where Storage: ~Copyable & ~Escapable {

    @inlinable
    @_lifetime(copy storage)
    public init(
        storage: consuming Storage,
        readerIndex: Ordinal
    ) throws(Binary.Reader<Storage>.Error) {
        let byteCount = storage.span.count
        let count = Cardinal(UInt(byteCount))

        guard let readerValue = Int(exactly: readerIndex.rawValue) else { throw .overflow }

        guard readerIndex.rawValue <= count.rawValue else {
            throw .bounds(
                value: readerValue,
                lower: 0,
                upper: Int(count.rawValue)
            )
        }

        self.storage = storage
        self._count = count
        self._readerIndex = readerIndex
    }
}

extension Binary.Reader where Storage: ~Copyable & ~Escapable {

    @inlinable
    @_lifetime(copy storage)
    public init(
        __unchecked: Void = (),
        storage: consuming Storage,
        readerIndex: Ordinal? = nil
    ) {
        let byteCount = storage.span.count
        let count = Cardinal(UInt(byteCount))
        let readerIndex = readerIndex ?? .zero
        precondition(Int(exactly: readerIndex.rawValue) != nil)
        precondition(readerIndex.rawValue <= count.rawValue)
        self.storage = storage
        self._count = count
        self._readerIndex = readerIndex
    }
}

extension Binary.Reader where Storage: ~Copyable & ~Escapable {

    @inlinable
    public var remainingCount: Cardinal {

        let reader = Int(_readerIndex.rawValue)
        let count = Int(_count.rawValue)
        return Cardinal(UInt(count - reader))
    }

    @inlinable
    public var hasRemaining: Bool {
        _readerIndex.rawValue < _count.rawValue
    }

    @inlinable
    public var isAtEnd: Bool {
        _readerIndex.rawValue >= _count.rawValue
    }
}

extension Binary.Reader where Storage: ~Copyable & ~Escapable {

    @inlinable
    public mutating func moveReaderIndex(
        by offset: Difference
    ) throws(Binary.Reader<Storage>.Error) {
        let currentReader = Int(_readerIndex.rawValue)
        let count = Int(_count.rawValue)
        guard let offsetValue = try? offset.intValue() else { throw .overflow }

        let (newIndex, overflow) = currentReader.addingReportingOverflow(offsetValue)

        guard !overflow else {
            throw .overflow
        }

        guard newIndex >= 0 else {
            throw .bounds(
                value: newIndex,
                lower: 0,
                upper: count
            )
        }

        guard newIndex <= count else {
            throw .bounds(
                value: newIndex,
                lower: 0,
                upper: count
            )
        }

        _readerIndex = Ordinal(UInt(newIndex))
    }

    @inlinable
    public mutating func moveReaderIndex(
        __unchecked: Void = (),
        by offset: Difference
    ) {
        let currentReader = Int(_readerIndex.rawValue)
        let count = Int(_count.rawValue)
        let offsetValue = _binaryWrappingOffset(offset)

        let newIndex = currentReader &+ offsetValue
        precondition(newIndex >= 0 && newIndex <= count)
        _readerIndex = Ordinal(UInt(newIndex))
    }
}

extension Binary.Reader where Storage: ~Copyable & ~Escapable {

    @inlinable
    public mutating func setReaderIndex(
        to position: Ordinal
    ) throws(Binary.Reader<Storage>.Error) {
        let count = Int(_count.rawValue)
        guard let positionValue = Int(exactly: position.rawValue) else { throw .overflow }

        guard positionValue <= count else {
            throw .bounds(
                value: positionValue,
                lower: 0,
                upper: count
            )
        }

        _readerIndex = position
    }

    @inlinable
    public mutating func setReaderIndex(
        __unchecked: Void = (),
        to position: Ordinal
    ) {
        let count = Int(_count.rawValue)
        guard let positionValue = Int(exactly: position.rawValue) else {
            preconditionFailure("Binary position is not representable as Int")
        }
        precondition(positionValue <= count)
        _readerIndex = position
    }
}

extension Binary.Reader where Storage: ~Copyable & ~Escapable {

    @inlinable
    public mutating func reset() {
        _readerIndex = .zero
    }
}

extension Binary.Reader where Storage: ~Copyable & ~Escapable {

    @inlinable
    public var remainingBytes: Swift.Span<Byte> {
        @_lifetime(borrow self)
        borrowing get {
            let readerIdx = Int(_readerIndex.rawValue)
            let storageCount = Int(_count.rawValue)
            return storage.span.extracting(readerIdx..<storageCount)
        }
    }

    @inlinable
    public func withRemainingBytes<R, E: Swift.Error>(
        _ body: (UnsafeRawBufferPointer) throws(E) -> R
    ) throws(E) -> R {
        let span = remainingBytes
        return try span.withUnsafeBytes {
            (rawBuffer: UnsafeRawBufferPointer) throws(E) -> R in
            try unsafe body(rawBuffer)
        }
    }
}
#endif
