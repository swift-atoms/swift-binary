import Binary_Test_Support
import Testing

@testable import Binary

extension Binary.Endianness {
    @Suite
    struct Test {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
        @Suite struct Integration {}
        @Suite(.serialized) struct Performance {}
    }
}

extension Binary.Endianness.Test.Unit {

    @Test
    func `cases are distinct`() {
        let little: Binary.Endianness = .little
        let big: Binary.Endianness = .big
        #expect(little != big)
    }

    @Test
    func `opposite swaps endianness`() {
        #expect(Binary.Endianness.little.opposite == .big)
        #expect(Binary.Endianness.big.opposite == .little)
    }

    @Test
    func `negation operator swaps endianness`() {
        #expect(!Binary.Endianness.little == .big)
        #expect(!Binary.Endianness.big == .little)
        #expect(!(!Binary.Endianness.little) == .little)
    }

    @Test
    func `CaseIterable conformance`() {
        #expect(Binary.Endianness.allCases.count == 2)
        #expect(Binary.Endianness.allCases.contains(.little))
        #expect(Binary.Endianness.allCases.contains(.big))
    }

    @Test
    func `network is big-endian`() {
        #expect(Binary.Endianness.network == .big)
    }

    @Test
    func `native is one of the valid values`() {

        let native = Binary.Endianness.native
        #expect(native == .little || native == .big)
    }
}
