public import Binary_Endianness_Primitives

extension [UInt8] {

    @inlinable
    public init<T: FixedWidthInteger>(_ value: T, endianness: Binary.Endianness = .little) {
        let converted: T
        switch endianness {
        case .little:
            converted = value.littleEndian

        case .big:
            converted = value.bigEndian
        }
        (self = Swift.withUnsafeBytes(of: converted) { unsafe Array($0) })
    }
}

extension [UInt8] {

    @inlinable
    public init<C: Swift.Collection>(serializing values: C, endianness: Binary.Endianness = .little)
    where C.Element: FixedWidthInteger {
        var result: [UInt8] = []
        result.reserveCapacity(values.count * MemoryLayout<C.Element>.size)
        for value in values {
            result.append(contentsOf: [UInt8](value, endianness: endianness))
        }
        self = result
    }
}

extension [UInt8] {

    @inlinable
    public init(utf8 string: some StringProtocol) {
        self = Array(string.utf8)
    }
}

extension [UInt8] {

    @inlinable
    public static func split(_ bytes: [UInt8], separator: [UInt8]) -> [[UInt8]] {
        guard !separator.isEmpty else { return [bytes] }

        var result: [[UInt8]] = []
        var start = 0

        while start < bytes.count {
            guard start + separator.count <= bytes.count else {
                result.append(Array(bytes[start...]))
                break
            }

            guard
                let i = (start...(bytes.count - separator.count)).first(where: {
                    bytes[$0..<$0 + separator.count].elementsEqual(separator)
                })
            else {
                result.append(Array(bytes[start...]))
                break
            }
            result.append(Array(bytes[start..<i]))
            start = i + separator.count
        }

        return result
    }

    @inlinable
    public func split(separator: [UInt8]) -> [[UInt8]] {
        Self.split(self, separator: separator)
    }
}

extension [UInt8] {

    @inlinable
    public mutating func append(_ value: UInt16, endianness: Binary.Endianness = .little) {
        append(contentsOf: value.bytes(endianness: endianness).underlying)
    }

    @inlinable
    public mutating func append(_ value: UInt32, endianness: Binary.Endianness = .little) {
        append(contentsOf: value.bytes(endianness: endianness).underlying)
    }

    @inlinable
    public mutating func append(_ value: UInt64, endianness: Binary.Endianness = .little) {
        append(contentsOf: value.bytes(endianness: endianness).underlying)
    }

    @inlinable
    public mutating func append(_ value: Int16, endianness: Binary.Endianness = .little) {
        append(contentsOf: value.bytes(endianness: endianness).underlying)
    }

    @inlinable
    public mutating func append(_ value: Int32, endianness: Binary.Endianness = .little) {
        append(contentsOf: value.bytes(endianness: endianness).underlying)
    }

    @inlinable
    public mutating func append(_ value: Int64, endianness: Binary.Endianness = .little) {
        append(contentsOf: value.bytes(endianness: endianness).underlying)
    }

    @inlinable
    public mutating func append(_ value: Int, endianness: Binary.Endianness) {
        append(contentsOf: value.bytes(endianness: endianness).underlying)
    }

    @inlinable
    public mutating func append(_ value: UInt, endianness: Binary.Endianness) {
        append(contentsOf: value.bytes(endianness: endianness).underlying)
    }
}

extension [[UInt8]] {

    @inlinable
    public func joined(separator: [UInt8]) -> [UInt8] {
        guard !isEmpty else { return [] }
        guard count > 1 else { return self[0] }

        let totalBytes = reduce(0) { $0 + $1.count }
        let totalSeparators = separator.count * dropLast().count
        let totalCapacity = totalBytes + totalSeparators

        var result: [UInt8] = []
        result.reserveCapacity(totalCapacity)

        var isFirst = true
        for element in self {
            if !isFirst {
                result.append(contentsOf: separator)
            }
            result.append(contentsOf: element)
            isFirst = false
        }

        return result
    }

    @inlinable
    public func joined() -> [UInt8] {
        guard !isEmpty else { return [] }
        guard count > 1 else { return self[0] }

        let totalBytes = reduce(0) { $0 + $1.count }

        var result: [UInt8] = []
        result.reserveCapacity(totalBytes)

        for element in self {
            result.append(contentsOf: element)
        }

        return result
    }
}
