//
//  AnyTopLevelDecoder.swift
//  CryptoCoins
//
//  Created by Michael Chan on 12/06/2025.
//

import Foundation
import Combine

public struct AnyTopLevelDecoder<Input>: TopLevelDecoder {
    public typealias Input = Input
    private let performDecode: (Any.Type, Input) throws -> Any
    
    public init<T: TopLevelDecoder> (decoder: T) where T.Input == Input  {
        
        performDecode = { type, input in
            guard let decodableType = type as? Decodable.Type else {
                fatalError("AnyTopLevelDecoder: Attempted to decode non-Decodable type.")
            }
            
            return try decoder.decode(decodableType, from: input)
        }
    }
    
    public func decode<T>(_ type: T.Type, from: Input) throws -> T where T : Decodable {
        return try performDecode(type, from) as! T
    }
}
