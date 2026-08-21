extension Binary {

    public enum Endianness: Sendable, Hashable, CaseIterable {

        case little

        case big
    }
}

extension Binary.Endianness {

    @inlinable
    public static func opposite(_ endianness: Binary.Endianness) -> Binary.Endianness {
        switch endianness {
        case .little: return .big
        case .big: return .little
        }
    }

    @inlinable
    public var opposite: Binary.Endianness {
        Self.opposite(self)
    }

    @inlinable
    public static prefix func ! (value: Binary.Endianness) -> Binary.Endianness {
        opposite(value)
    }
}

extension Binary.Endianness {

    @inlinable
    public static var native: Binary.Endianness {
        #if _endian(little)
            return .little
        #else
            return .big
        #endif
    }

    @inlinable
    public static var network: Binary.Endianness { .big }
}

#if !hasFeature(Embedded)
    extension Binary.Endianness: Codable {}
#endif
