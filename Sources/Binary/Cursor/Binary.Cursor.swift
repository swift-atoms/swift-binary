#if Cursor
public import Byte
public import Cardinal
public import Difference
public import Ordinal
public import Span

extension Binary {

    public struct Cursor<Storage: Span::__Span.`Protocol` & ~Copyable & ~Escapable>: ~Copyable, ~Escapable
    where Storage.Element == Byte {

        public let storage: Storage

        @usableFromInline
        internal let _count: Cardinal

        @usableFromInline
        internal var _readerIndex: Ordinal

        @usableFromInline
        internal var _writerIndex: Ordinal

        @inlinable
        @_lifetime(copy storage)
        public init(storage: consuming Storage) {
            let byteCount = storage.span.count
            self.storage = storage
            self._count = Cardinal(UInt(byteCount))
            self._readerIndex = .zero
            self._writerIndex = .zero
        }
    }
}

extension Binary.Cursor where Storage: ~Copyable & ~Escapable {

    public var readerIndex: Ordinal {
        _readerIndex
    }

    public var writerIndex: Ordinal {
        _writerIndex
    }

    public var count: Cardinal {
        _count
    }
}

extension Binary.Cursor where Storage: ~Copyable & ~Escapable {

    @inlinable
    @_lifetime(copy storage)
    public init(
        storage: consuming Storage,
        readerIndex: Ordinal,
        writerIndex: Ordinal
    ) throws(Binary.Cursor<Storage>.Error) {
        let byteCount = storage.span.count
        let count = Cardinal(UInt(byteCount))

        guard let readerValue = Int(exactly: readerIndex.rawValue) else { throw .overflow(.reader) }
        guard let writerValue = Int(exactly: writerIndex.rawValue) else { throw .overflow(.writer) }

        guard writerIndex >= readerIndex else {
            throw .invariant(
                reader: readerValue,
                writer: writerValue
            )
        }

        guard writerIndex.rawValue <= count.rawValue else {
            throw .bounds(
                .writer,
                value: writerValue,
                lower: 0,
                upper: Int(count.rawValue)
            )
        }

        self.storage = storage
        self._count = count
        self._readerIndex = readerIndex
        self._writerIndex = writerIndex
    }
}

extension Binary.Cursor where Storage: ~Copyable & ~Escapable {

    @inlinable
    @_lifetime(copy storage)
    public init(
        __unchecked: Void = (),
        storage: consuming Storage,
        readerIndex: Ordinal,
        writerIndex: Ordinal
    ) {
        let byteCount = storage.span.count
        let count = Cardinal(UInt(byteCount))
        precondition(Int(exactly: readerIndex.rawValue) != nil)
        precondition(Int(exactly: writerIndex.rawValue) != nil)
        precondition(writerIndex >= readerIndex)
        precondition(writerIndex.rawValue <= count.rawValue)
        self.storage = storage
        self._count = count
        self._readerIndex = readerIndex
        self._writerIndex = writerIndex
    }
}

extension Binary.Cursor where Storage: ~Copyable & ~Escapable {

    @inlinable
    public var readableCount: Cardinal {

        let reader = Int(_readerIndex.rawValue)
        let writer = Int(_writerIndex.rawValue)
        return Cardinal(UInt(writer - reader))
    }

    @inlinable
    public var writableCount: Cardinal {

        let writer = Int(_writerIndex.rawValue)
        let count = Int(_count.rawValue)
        return Cardinal(UInt(count - writer))
    }

    @inlinable
    public var isReadable: Bool {
        _writerIndex > _readerIndex
    }

    @inlinable
    public var isWritable: Bool {
        _writerIndex.rawValue < _count.rawValue
    }
}

extension Binary.Cursor where Storage: ~Copyable & ~Escapable {

    @inlinable
    public mutating func moveReaderIndex(
        by offset: Difference
    ) throws(Binary.Cursor<Storage>.Error) {
        let currentReader = Int(_readerIndex.rawValue)
        let currentWriter = Int(_writerIndex.rawValue)
        guard let offsetValue = try? offset.intValue() else { throw .overflow(.reader) }

        let (newIndex, overflow) = currentReader.addingReportingOverflow(offsetValue)

        guard !overflow else {
            throw .overflow(.reader)
        }

        guard newIndex >= 0 else {
            throw .bounds(
                .reader,
                value: newIndex,
                lower: 0,
                upper: currentWriter
            )
        }

        guard newIndex <= currentWriter else {
            throw .invariant(reader: newIndex, writer: currentWriter)
        }

        _readerIndex = Ordinal(UInt(newIndex))
    }

    @inlinable
    public mutating func moveReaderIndex(
        __unchecked: Void = (),
        by offset: Difference
    ) {
        let currentReader = Int(_readerIndex.rawValue)
        let currentWriter = Int(_writerIndex.rawValue)
        let offsetValue = _binaryWrappingOffset(offset)

        let newIndex = currentReader &+ offsetValue
        precondition(newIndex >= 0 && newIndex <= currentWriter)
        _readerIndex = Ordinal(UInt(newIndex))
    }
}

extension Binary.Cursor where Storage: ~Copyable & ~Escapable {

    @inlinable
    public mutating func moveWriterIndex(
        by offset: Difference
    ) throws(Binary.Cursor<Storage>.Error) {
        let currentReader = Int(_readerIndex.rawValue)
        let currentWriter = Int(_writerIndex.rawValue)
        let count = Int(_count.rawValue)
        guard let offsetValue = try? offset.intValue() else { throw .overflow(.writer) }

        let (newIndex, overflow) = currentWriter.addingReportingOverflow(offsetValue)

        guard !overflow else {
            throw .overflow(.writer)
        }

        guard newIndex >= currentReader else {
            throw .invariant(reader: currentReader, writer: newIndex)
        }

        guard newIndex <= count else {
            throw .bounds(
                .writer,
                value: newIndex,
                lower: currentReader,
                upper: count
            )
        }

        _writerIndex = Ordinal(UInt(newIndex))
    }

    @inlinable
    public mutating func moveWriterIndex(
        __unchecked: Void = (),
        by offset: Difference
    ) {
        let currentReader = Int(_readerIndex.rawValue)
        let currentWriter = Int(_writerIndex.rawValue)
        let count = Int(_count.rawValue)
        let offsetValue = _binaryWrappingOffset(offset)

        let newIndex = currentWriter &+ offsetValue
        precondition(newIndex >= currentReader && newIndex <= count)
        _writerIndex = Ordinal(UInt(newIndex))
    }
}

extension Binary.Cursor where Storage: ~Copyable & ~Escapable {

    @inlinable
    public mutating func setReaderIndex(
        to position: Ordinal
    ) throws(Binary.Cursor<Storage>.Error) {
        let currentWriter = Int(_writerIndex.rawValue)
        guard let positionValue = Int(exactly: position.rawValue) else { throw .overflow(.reader) }

        guard positionValue <= currentWriter else {
            throw .invariant(reader: positionValue, writer: currentWriter)
        }

        _readerIndex = position
    }

    @inlinable
    public mutating func setReaderIndex(
        __unchecked: Void = (),
        to position: Ordinal
    ) {
        let currentWriter = Int(_writerIndex.rawValue)
        guard let positionValue = Int(exactly: position.rawValue) else {
            preconditionFailure("Binary position is not representable as Int")
        }
        precondition(positionValue <= currentWriter)
        _readerIndex = position
    }
}

extension Binary.Cursor where Storage: ~Copyable & ~Escapable {

    @inlinable
    public mutating func setWriterIndex(
        to position: Ordinal
    ) throws(Binary.Cursor<Storage>.Error) {
        let currentReader = Int(_readerIndex.rawValue)
        let count = Int(_count.rawValue)
        guard let positionValue = Int(exactly: position.rawValue) else { throw .overflow(.writer) }

        guard positionValue >= currentReader else {
            throw .invariant(reader: currentReader, writer: positionValue)
        }

        guard positionValue <= count else {
            throw .bounds(
                .writer,
                value: positionValue,
                lower: currentReader,
                upper: count
            )
        }

        _writerIndex = position
    }

    @inlinable
    public mutating func setWriterIndex(
        __unchecked: Void = (),
        to position: Ordinal
    ) {
        let currentReader = Int(_readerIndex.rawValue)
        let count = Int(_count.rawValue)
        guard let positionValue = Int(exactly: position.rawValue) else {
            preconditionFailure("Binary position is not representable as Int")
        }
        precondition(positionValue >= currentReader && positionValue <= count)
        _writerIndex = position
    }
}

extension Binary.Cursor where Storage: ~Copyable & ~Escapable {

    @inlinable
    public mutating func reset() {
        _readerIndex = .zero
        _writerIndex = .zero
    }
}

extension Binary.Cursor where Storage: ~Copyable & ~Escapable {

    @inlinable
    public var readableBytes: Swift.Span<Byte> {
        @_lifetime(borrow self)
        borrowing get {
            let readerIdx = Int(_readerIndex.rawValue)
            let writerIdx = Int(_writerIndex.rawValue)
            return storage.span.extracting(readerIdx..<writerIdx)
        }
    }

    @inlinable
    public func withReadableBytes<R, E: Swift.Error>(
        _ body: (UnsafeRawBufferPointer) throws(E) -> R
    ) throws(E) -> R {
        let span = readableBytes
        return try span.withUnsafeBytes {
            (rawBuffer: UnsafeRawBufferPointer) throws(E) -> R in
            try unsafe body(rawBuffer)
        }
    }
}
#endif
