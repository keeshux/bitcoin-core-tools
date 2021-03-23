//
//  ColdcardDevice.swift
//  
//
//  Created by Davide De Rosa on 2/20/21.
//

import Foundation
import BitcoinTools

public struct ColdcardDevice: WalletDevice, Codable {
    public enum LocalChain: String, Codable {
        case btc = "BTC"
        
        case xtn = "XTN"
    }
    
    public struct ChildKey: Codable {
        public enum CodingKeys: String, CodingKey {
            case xpub
            
            case fingerprint = "xfp"

            case derivationPath = "deriv"
            
            case firstAddress = "first"
        }

        let xpub: XPUBKey

        let fingerprint: HDFingerprint

        let derivationPath: HDDerivationPath

        let firstAddress: String
    }

    public enum CodingKeys: String, CodingKey {
        case localChain = "chain"

        case xpub

        case fingerprint = "xfp"

        case account
        
        case bip44

        case bip49

        case bip84
    }

    public let localChain: LocalChain
    
    public var network: Network {
        switch localChain {
        case .btc:
            return .mainnet
            
        case .xtn:
            return .testnet
        }
    }

    public let xpub: XPUBKey
    
    public let fingerprint: HDFingerprint
    
    public let account: UInt
    
    public let bip44: ChildKey

    public let bip49: ChildKey

    public let bip84: ChildKey
    
    private func child(forPurpose purpose: HDPurpose) -> ChildKey {
        switch purpose {
        case .bip44:
            return bip44
            
        case .bip49:
            return bip49
            
        case .bip84:
            return bip84
        }
    }
    
    // MARK: WalletDevice
    
    public let purposes: [HDPurpose] = [
        .bip84,
        .bip49,
        .bip44
    ]
    
    public func singleKey(forPurpose purpose: HDPurpose) -> WalletSingleKey {
        let target = child(forPurpose: purpose)
        return WalletSingleKey(
            purpose: purpose,
            masterFingerprint: fingerprint,
            derivationPath: target.derivationPath,
            xpub: target.xpub,
            externalAddresses: [target.firstAddress]
        )
    }

    // MARK: CustomStringConvertible
    
    public let description = "Coldcard"
}
