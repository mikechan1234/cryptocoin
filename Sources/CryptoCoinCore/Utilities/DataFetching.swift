//
//  DataFetching.swift
//  CryptoCoins
//
//  Created by Michael Chan on 12/06/2025.
//

import Foundation
import Combine

public protocol DataFetching {
    func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure>
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: DataFetching {
    public func dataTaskPublisher(for request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure> {
        let dataTaskPublisher: URLSession.DataTaskPublisher = dataTaskPublisher(for: request)
        return dataTaskPublisher.eraseToAnyPublisher()
    }
}
