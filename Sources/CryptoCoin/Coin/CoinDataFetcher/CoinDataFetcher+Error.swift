//
//  CoinDataSourceError.swift
//  CryptoCoins
//
//  Created by Michael Chan on 11/06/2025.
//

import Foundation

extension CoinDataFetcher {
    public enum Error: Swift.Error, Equatable {
        case unknown
        case decodingFailed
        case malformedURL
        case invalidURLResponse
        case invalidStatusCode(Int)
    }
}
