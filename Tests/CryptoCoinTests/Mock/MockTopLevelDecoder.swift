//
//  MockTopLevelDecoder.swift
//  CryptoCoinsTests
//
//  Created by Michael Chan on 12/06/2025.
//

import Foundation
import Combine

struct MockTopLevelDecoder: TopLevelDecoder {
    typealias Input = Data
    
    private let result: Result<any Decodable, Error>
    
    init(result: Result<any Decodable, Error>) {
        self.result = result
    }
    
    func decode<T>(_ type: T.Type, from: Data) throws -> T where T : Decodable {
        switch result {
            case .success(let success):
                return success as! T
            case .failure(let failure):
                throw failure
        }
    }
}
