//
//  BlockchainInfo+Tools.swift
//  
//
//  Created by Davide De Rosa on 3/23/21.
//

import Foundation
import BitcoinAPI
import BitcoinTools

extension BlockchainInfo.Chain {
    public var network: Network {
        switch self {
        case .main:
            return .mainnet
            
        case .test:
            return .testnet
        }
    }
}
