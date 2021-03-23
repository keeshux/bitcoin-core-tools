//
//  Encoding+Bech32.swift
//  
//
//  Created by Davide De Rosa on 2/21/21.
//

import Foundation
@testable import Bech32

private let coder = Bech32()

extension Bech32 {
    enum HRP: String {
        case main = "bc"
        
        case test = "tb"
    
        var network: Network {
            switch self {
            case .main:
                return .mainnet
                
            case .test:
                return .testnet
            }
        }
    }
}

extension Network {
    var hrp: Bech32.HRP {
        switch self {
        case .mainnet:
            return .main
            
        case .testnet:
            return .test
        }
    }
}

extension Data {
    public func bech32String(forNetwork network: Network) -> String {
        return coder.encode(network.hrp.rawValue, values: self)
    }
}

extension String {
    public var bech32Data: (Network, Data)? {
        guard let (hrpValue, data) = try? coder.decode(self) else {
            return nil
        }
        guard let hrp = Bech32.HRP(rawValue: hrpValue) else {
            return nil
        }
        return (hrp.network, data)
    }
}
