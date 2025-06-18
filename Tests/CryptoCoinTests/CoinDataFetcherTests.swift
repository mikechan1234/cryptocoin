//
//  CoinDataSourceUnits.swift
//  CryptoCoinsTests
//
//  Created by Michael Chan on 12/06/2025.
//

import Foundation
import Testing

@testable import CryptoCoin

@Suite("CoinDataFetcher Unit Tests")
class CoinDataFetcherTests {
    
    let jsonDecoder = JSONDecoder()

    @Test("Test that the coins Combine function method works")
    func fetchCoinsWorks() async throws {
        let dataURL = try #require(
            Bundle.module.url(forResource: "coins_response_valid", withExtension: "json")
        )
        let data = try Data(contentsOf: dataURL)
        let expectedResponse = try jsonDecoder.decode(CoinResponse.self, from: data)
        let httpResponse = try #require(
            HTTPURLResponse(url: dataURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        )
        let mockTopLevelDecoder = MockTopLevelDecoder(result: .success(expectedResponse))
        let decoder = AnyTopLevelDecoder(decoder: mockTopLevelDecoder)
        let dataFetcher = MockDataFetcher(result: .success(
            (data: data, response: httpResponse))
        )
        
        let fetcher = CoinDataFetcher(decoder: decoder, fetcher: dataFetcher)
        
        let values = fetcher.coins().values
        guard let receivedValue = try await values.first(where: { _ in
            true
        }) else {
            #expect(Bool(false))
            return
        }
        
        #expect(receivedValue == expectedResponse.data.coins)
    }
    
    @Test("Test coins Combine function throws when URLResponse object returned is not HTTPURLResponse object")
    func fetchCoinThrowsWhenURLResponseIsNotHTTPURLResponse() async throws {
        let dataURL = try #require(
            Bundle.module.url(forResource: "coins_response_valid", withExtension: "json")
        )
        let data = try Data(contentsOf: dataURL)
        let expectedResponse = try jsonDecoder.decode(CoinResponse.self, from: data)
        let urlResponse = URLResponse()
        let mockTopLevelDecoder = MockTopLevelDecoder(result: .success(expectedResponse))
        let decoder = AnyTopLevelDecoder(decoder: mockTopLevelDecoder)
        let dataFetcher = MockDataFetcher(result: .success(
            (data: data, response: urlResponse))
        )
        
        let fetcher = CoinDataFetcher(decoder: decoder, fetcher: dataFetcher)
        
        let error = await #expect(throws: CoinDataFetcher.Error.self) {
            try await fetcher.coins().values.first { _ in
                true
            }
        }
        #expect(error == CoinDataFetcher.Error.invalidURLResponse)
    }
    
    @Test("Test coins Combine function throws an error with the HTTP status code is not 2xx")
    func fetchCoinThrowsWhenHTTPStatusCodeIsInvalid() async throws {
        let dataURL = try #require(
            Bundle.module.url(forResource: "coins_response_valid", withExtension: "json")
        )
        let data = try Data(contentsOf: dataURL)
        let expectedResponse = try jsonDecoder.decode(CoinResponse.self, from: data)
        let urlResponse = try #require(
            HTTPURLResponse(url: dataURL, statusCode: 300, httpVersion: nil, headerFields: nil)
        )
        let mockTopLevelDecoder = MockTopLevelDecoder(result: .success(expectedResponse))
        let decoder = AnyTopLevelDecoder(decoder: mockTopLevelDecoder)
        let dataFetcher = MockDataFetcher(result: .success(
            (data: data, response: urlResponse))
        )
        
        let fetcher = CoinDataFetcher(decoder: decoder, fetcher: dataFetcher)
        
        let error = await #expect(throws: CoinDataFetcher.Error.self) {
            try await fetcher.coins().values.first { _ in
                true
            }
        }
        
        #expect(error == .invalidStatusCode(300))
    }
    
    @Test("Test coins Combine function throws when the data decoding fails")
    func fetchCoinThrowsWhenDataCannotBeDecoded() async throws {
        let dataURL = try #require(
            Bundle.module.url(forResource: "coins_response_valid", withExtension: "json")
        )
        
        let data = Data()
        let urlResponse = try #require(
            HTTPURLResponse(url: dataURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        )
        let mockTopLevelDecoder = MockTopLevelDecoder(result: .failure(
            DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: ""))
        ))
        let decoder = AnyTopLevelDecoder(decoder: mockTopLevelDecoder)
        let dataFetcher = MockDataFetcher(result: .success(
            (data: data, response: urlResponse))
        )
        
        let fetcher = CoinDataFetcher(decoder: decoder, fetcher: dataFetcher)
        
        let error = await #expect(throws: CoinDataFetcher.Error.self) {
            try await fetcher.coins().values.first { _ in
                true
            }
        }
        
        #expect(error == .requestFailed)
    }
    
    @Test("Test coins async await function method works")
    func fetchCoinAsyncAwaitMethodWorks() async throws {
        let dataURL = try #require(
            Bundle.module.url(forResource: "coins_response_valid", withExtension: "json")
        )
        let data = try Data(contentsOf: dataURL)
        let expectedResponse = try jsonDecoder.decode(CoinResponse.self, from: data)
        let httpResponse = try #require(
            HTTPURLResponse(url: dataURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        )
        let mockTopLevelDecoder = MockTopLevelDecoder(result: .success(expectedResponse))
        let decoder = AnyTopLevelDecoder(decoder: mockTopLevelDecoder)
        let dataFetcher = MockDataFetcher(result: .success(
            (data: data, response: httpResponse))
        )
        
        let fetcher = CoinDataFetcher(decoder: decoder, fetcher: dataFetcher)
        
        let value = try await fetcher.coins()
        #expect(value == expectedResponse.data.coins)
    }
    
    @Test("Test coins async await function throws when URLResponse object returned is not HTTPURLResponse object")
    func fetchCoinAsyncAwaitMethodThrowsWhenURLResponseIsNotHTTPURLResponse() async throws {
        let dataURL = try #require(
            Bundle.module.url(forResource: "coins_response_valid", withExtension: "json")
        )
        let data = try Data(contentsOf: dataURL)
        let expectedResponse = try jsonDecoder.decode(CoinResponse.self, from: data)
        let urlResponse = URLResponse()
        let mockTopLevelDecoder = MockTopLevelDecoder(result: .success(expectedResponse))
        let decoder = AnyTopLevelDecoder(decoder: mockTopLevelDecoder)
        let dataFetcher = MockDataFetcher(result: .success(
            (data: data, response: urlResponse))
        )
        
        let fetcher = CoinDataFetcher(decoder: decoder, fetcher: dataFetcher)
        
        let error = await #expect(throws: CoinDataFetcher.Error.self) {
            _ = try await fetcher.coins()
        }
        
        #expect(error == CoinDataFetcher.Error.invalidURLResponse)
    }
    
    @Test("Test coins async await function throws an error with the HTTP status code is not 2xx")
    func fetchCoinAsyncAwaitMethodThrowsWhenHTTPStatusCodeIsInvalid() async throws {
        let dataURL = try #require(
            Bundle.module.url(forResource: "coins_response_valid", withExtension: "json")
        )
        let data = try Data(contentsOf: dataURL)
        let expectedResponse = try jsonDecoder.decode(CoinResponse.self, from: data)
        let urlResponse = try #require(
            HTTPURLResponse(url: dataURL, statusCode: 300, httpVersion: nil, headerFields: nil)
        )
        let mockTopLevelDecoder = MockTopLevelDecoder(result: .success(expectedResponse))
        let decoder = AnyTopLevelDecoder(decoder: mockTopLevelDecoder)
        let dataFetcher = MockDataFetcher(result: .success(
            (data: data, response: urlResponse))
        )
        
        let fetcher = CoinDataFetcher(decoder: decoder, fetcher: dataFetcher)
        
        let error = await #expect(throws: CoinDataFetcher.Error.self) {
            _ = try await fetcher.coins()
        }
        
        #expect(error == .invalidStatusCode(300))
    }
    
    @Test("Test coins async await function throws when the data decoding fails")
    func fetchCoinAsyncAwaitMethodThrowsWhenDataCannotBeDecoded() async throws {
        let dataURL = try #require(
            Bundle.module.url(forResource: "coins_response_valid", withExtension: "json")
        )
        
        let data = Data()
        let urlResponse = try #require(
            HTTPURLResponse(url: dataURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        )
        let mockTopLevelDecoder = MockTopLevelDecoder(result: .failure(
            DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: ""))
        ))
        let decoder = AnyTopLevelDecoder(decoder: mockTopLevelDecoder)
        let dataFetcher = MockDataFetcher(result: .success(
            (data: data, response: urlResponse))
        )
        
        let fetcher = CoinDataFetcher(decoder: decoder, fetcher: dataFetcher)
        
        let error = await #expect(throws: CoinDataFetcher.Error.self) {
            _ = try await fetcher.coins()
        }
        
        #expect(error == .requestFailed)
    }
}
