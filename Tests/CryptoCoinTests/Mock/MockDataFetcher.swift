//
//  MockDataFetcher.swift
//  CryptoCoinsTests
//
//  Created by Michael Chan on 12/06/2025.
//

@testable import CryptoCoins
import Foundation
import Combine

struct MockDataFetcher: DataFetching {
    private let result: Result<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure>
    
    init(result: Result<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure>) {
        self.result = result
    }
    
    func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure> {
        Future<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure> { promise in
            promise(result)
        }.eraseToAnyPublisher()
    }
}
