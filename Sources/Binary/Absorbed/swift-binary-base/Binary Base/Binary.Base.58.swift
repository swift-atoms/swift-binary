#if Base
    extension Binary.Base {

        public struct `58`: Sendable {

            public init() {}
        }
    }
#endif

#if Base
    public import Property

    extension Binary.Base.`58` {

        public static var decode: Property<Binary.Base.Decode, Self> {
            Property<Binary.Base.Decode, Self>(.init())
        }
    }
#endif

#if Base
    public import Property

    extension Binary.Base.`58` {

        public static var encode: Property<Binary.Base.Encode, Self> {
            Property<Binary.Base.Encode, Self>(.init())
        }
    }
#endif
