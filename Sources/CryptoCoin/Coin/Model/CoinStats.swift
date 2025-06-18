//
//  CoinStats.swift
//  CryptoCoins
//
//  Created by Michael Chan on 26/05/2025.
//

import Foundation

public struct CoinStats: Decodable {
    public let total: Int
    public let totalCoins: Int
    public let totalMarkets: Int
    public let totalExchanges: Int
    public let totalMarketCap: String
    public let total24hVolume: String
}
