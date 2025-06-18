//
//  AnyTopLevelDecoderTests.swift
//  CryptoCoinsTests
//
//  Created by Michael Chan on 15/06/2025.
//

@testable import CryptoCoinCore
import Foundation
import Testing

struct AnyTopLevelDecoderTests {

    @Test("Test the decoder works as expected")
    func testDecoder() async throws {
        let expectedResult = "Test"
        let mockDecoder = MockTopLevelDecoder(result: .success(expectedResult))
        let decoder = AnyTopLevelDecoder<Data>(decoder: mockDecoder)
        
        let result = try decoder.decode(String.self, from: Data())
        
        #expect(result == expectedResult)
    }
    
    @Test("Test the decoder works when the mockDecoder throws")
    func testDecoderWhenDecoderThrows() async throws {
        let expectedResult = CoinDataFetcher.Error.unknown
        let mockDecoder = MockTopLevelDecoder(result: .failure(expectedResult))
        let decoder = AnyTopLevelDecoder(decoder: mockDecoder)
        
        let result = #expect(throws: CoinDataFetcher.Error.self) {
            try decoder.decode(String.self, from: Data())
        }
        
        #expect(result == expectedResult)
    }
}
