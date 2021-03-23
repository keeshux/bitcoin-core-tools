//
//  UTXO.swift
//  
//
//  Created by Davide De Rosa on 3/9/21.
//

import Foundation

public struct UTXO: Codable {
    public let txid: String

    public let vout: Int

    public let address: String
    
    public let scriptPubKey: String

    public let amount: Double

    public let confirmations: Int

    public let spendable: Bool
    
    public let solvable: Bool

    public let desc: String

    public let safe: Bool
}
