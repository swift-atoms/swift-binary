#if Base
    extension Binary.Base {

        public struct `16`: Sendable {

            public init() {}
        }
    }
#endif

#if Base
    public import Property

    extension Binary.Base.`16` {

        public static var decode: Property<Binary.Base.Decode, Self> {
            Property<Binary.Base.Decode, Self>(.init())
        }
    }
#endif

#if Base
    public import Property

    extension Binary.Base.`16` {

        public static var encode: Property<Binary.Base.Encode, Self> {
            Property<Binary.Base.Encode, Self>(.init())
        }
    }
#endif
