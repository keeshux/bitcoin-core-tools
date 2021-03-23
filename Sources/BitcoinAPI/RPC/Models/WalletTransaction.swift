//
//  WalletTransaction.swift
//  
//
//  Created by Davide De Rosa on 3/9/21.
//

import Foundation

public struct WalletTransaction: Codable {
    public enum Category: String, Codable {
        case send
        
        case receive
    }
    
    public enum Bip25Replaceable: String, Codable {
        case yes
        
        case no
        
        case unknown
    }
    
    enum CodingKeys: String, CodingKey {
        case amount
        
        case fee
        
        case address
        
        case category
        
        case confirmations
        
        case blockHash = "blockhash"
        
        case blockHeight = "blockheight"
        
        case blockTime = "blocktime"
        
        case txid

        case time

        case timeReceived = "timereceived"
        
        case bip125Replaceable = "bip125-replaceable"
        
        case hex
    }
    
    public let amount: Double
    
    public let fee: Double?
    
    public let address: String?
    
    public let category: Category?
    
    public let confirmations: Int
    
    public let blockHash: String
    
    public let blockHeight: Int
    
    public let blockTime: Int
    
    public let txid: String
    
    public let time: Int

    public let timeReceived: Int
    
    public let bip125Replaceable: Bip25Replaceable
    
    public let hex: String?
}
