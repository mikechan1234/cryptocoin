//
//  CoinResponse.swift
//  CryptoCoins
//
//  Created by Michael Chan on 26/05/2025.
//

import Foundation

public struct CoinResponse: Decodable {
    public let status: String
    public let data: CoinData
}
