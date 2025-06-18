//
//  CoinDataSource.swift
//  CryptoCoins
//
//  Created by Michael Chan on 11/06/2025.
//

import Foundation
import Combine

public protocol CoinDataFetching {
    func coins() -> AnyPublisher<[Coin], CoinDataFetcher.Error>
}

public struct CoinDataFetcher: CoinDataFetching {
    private let fetcher: DataFetching
    private let decoder: AnyTopLevelDecoder<Data> //Can't use protocol here.
    
    public init(decoder: AnyTopLevelDecoder<Data>, fetcher: DataFetching) {
        self.decoder = decoder
        self.fetcher = fetcher
    }
    
    public func coins() -> AnyPublisher<[Coin], CoinDataFetcher.Error> {
        do {
            let urlRequest = try createRequest()
            
            return fetcher.dataTaskPublisher(for: urlRequest)
                .tryMap { value in
                    
                    guard let httpResponse = value.response as? HTTPURLResponse else {
                        throw Error.invalidURLResponse
                    }
                    
                    return (data: value.data, response: httpResponse)
                }.tryFilter { (data: Data, response: HTTPURLResponse) in
                    switch response.statusCode {
                        case 200..<300:
                            return true
                        default:
                            throw Error.invalidStatusCode(response.statusCode)
                    }
                }
                .map(\.0)
                .decode(type: CoinResponse.self, decoder: decoder)
                .map(\.data.coins)
                .mapError({ value in
                    guard let error = value as? CoinDataFetcher.Error else {
                        return .decodingFailed
                    }
                    return error
                })
                .eraseToAnyPublisher()
        } catch {
            return Fail(outputType: [Coin].self, failure: error)
                .eraseToAnyPublisher()
        }
    }
    
    private func createRequest() throws(CoinDataFetcher.Error) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.coinranking.com"
        urlComponents.path = "/v2/coins"
        
        guard let url = urlComponents.url else {
            throw .malformedURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("coinranking47cef9f934f8cd472c2b94541610b425589343eecd12266f", forHTTPHeaderField: "x-access-token")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return urlRequest
    }
}
