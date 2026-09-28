#if Base
public import Property

extension Binary.Base.`58` {

    public static var decode: Property<Binary.Base.Decode, Self> {
        Property<Binary.Base.Decode, Self>(.init())
    }
}
#endif
