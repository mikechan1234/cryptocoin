//
//  Coin.swift
//  CryptoCoins
//
//  Created by Michael Chan on 26/05/2025.
//

import Foundation

public struct Coin: Identifiable, Decodable, Equatable {
    public var id: String {
        get {
            uuid
        }
    }
    
    public let uuid: String
    public let symbol: String
    public let name: String
    public let color: String?
    public let iconUrl: URL
    public let marketCap: String
    public let price: String
    public let rank: Int
}
