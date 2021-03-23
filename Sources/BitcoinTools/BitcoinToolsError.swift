//
//  BitcoinToolsError.swift
//  
//
//  Created by Davide De Rosa on 2/21/21.
//

import Foundation

public enum BitcoinToolsError: LocalizedError {
    case hash256
    
    case base58
    
    case segwit
    
    case header
    
    case bip32Path
    
    case bip32Fingerprint
    
    case xpubSerializedLength
    
    // MARK: LocalizedError

    public var failureReason: String? {
        switch self {
        case .hash256:
            return "Not a Hash256"
            
        case .base58:
            return "Not a Base58 string"
            
        case .segwit:
            return "Not a Bech32 SegWit address"
            
        case .header:
            return "Malformed header"
            
        case .bip32Path:
            return "Malformed BIP32 derivation path"
            
        case .bip32Fingerprint:
            return "Malformed BIP32 fingerprint (must be 32-bit)"
            
        case .xpubSerializedLength:
            return "XPUB serialized length is incorrect"
        }
    }
}
