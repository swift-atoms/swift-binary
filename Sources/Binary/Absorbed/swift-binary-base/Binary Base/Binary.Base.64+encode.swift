#if Base
public import Property

extension Binary.Base.`64` {

    public static var encode: Property<Binary.Base.Encode, Self> {
        Property<Binary.Base.Encode, Self>(.init())
    }
}
#endif
