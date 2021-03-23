//
//  Block.swift
//
//
//  Created by Davide De Rosa on 2/17/21.
//

import Foundation

public struct Block: Codable {
    enum CodingKeys: String, CodingKey {
        case hash
        
        case confirmations
        
        case size
        
        case weight
        
        case version
        
        case merkleRoot = "merkleroot"
        
        case tx
        
        case time
        
        case medianTime = "mediantime"
        
        case nonce
        
        case bits
        
        case difficulty
        
        case chainWork = "chainwork"
    }
    
    public let hash: String
    
    public let confirmations: Int
    
    public let size: Int

    public let weight: Int

    public let version: Int

    public let merkleRoot: String

    public let tx: [String]

    public let time: Int
    
    public let medianTime: Int

    public let nonce: Int

    public let bits: String

    public let difficulty: Double

    public let chainWork: String
}
