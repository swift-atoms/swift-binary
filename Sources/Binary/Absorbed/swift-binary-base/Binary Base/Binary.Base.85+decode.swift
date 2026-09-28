#if Base
public import Property

extension Binary.Base.`85` {

    public static var decode: Property<Binary.Base.Decode, Self> {
        Property<Binary.Base.Decode, Self>(.init())
    }
}
#endif
