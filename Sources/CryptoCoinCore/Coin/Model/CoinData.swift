//
//  CoinsResponse.swift
//  CryptoCoins
//
//  Created by Michael Chan on 26/05/2025.
//

import Foundation

public struct CoinData: Decodable {
    public let stats: CoinStats
    public let coins: [Coin]
}
