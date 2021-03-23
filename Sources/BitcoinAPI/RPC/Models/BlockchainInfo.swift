//
//  BlockchainInfo.swift
//  
//
//  Created by Davide De Rosa on 3/6/21.
//

import Foundation

public struct BlockchainInfo: Codable {
    public enum Chain: String, Codable {
        case main = "main"
        
        case test = "test"
    }

    enum CodingKeys: String, CodingKey {
        case chain
        
        case blocks
        
        case headers
        
        case pruned
        
        case pruneHeight = "pruneheight"
        
        case verificationProgress = "verificationprogress"
    }
    
    public let chain: Chain
    
    public let blocks: Int
    
    public let headers: Int
    
    public let pruned: Bool
    
    public let pruneHeight: Int?
    
    public let verificationProgress: Double
}
