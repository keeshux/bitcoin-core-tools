//
//  Transaction.swift
//  
//
//  Created by Davide De Rosa on 3/9/21.
//

import Foundation

public struct Bip32Deriv: Codable {
    public enum CodingKeys: String, CodingKey {
        case pubkey

        case masterFingerprint = "master_fingerprint"

        case path
    }

    public let pubkey: String
    
    public let masterFingerprint: String
    
    public let path: String
}

public struct Transaction: Codable {
    public let txid: String

    public let version: Int
    
    public let size: Int

    public let vsize: Int
    
    public let weight: Int

    public let locktime: Int

    public let vin: [Vin]

    public let vout: [Vout]
}

extension Transaction {
    public struct Input: Codable {
        enum CodingKeys: String, CodingKey {
            case witnessUTXO = "witness_utxo"

            case nonWitnessUTXO = "non_witness_utxo"

            case bip32Derivs = "bip32_derivs"
        }

        public let witnessUTXO: WitnessUTXO

        public let nonWitnessUTXO: Transaction

        public let bip32Derivs: [Bip32Deriv]
    }

    public struct Output: Codable {
        enum CodingKeys: String, CodingKey {
            case bip32Derivs = "bip32_derivs"
        }

        public let bip32Derivs: [Bip32Deriv]?
    }

    public struct Vin: Codable {
        public struct ScriptSig: Codable {
            public let asm: String
            
            public let hex: String
        }

        public let txid: String

        public let vout: Int

        public let scriptSig: ScriptSig?

        public let sequence: Int
    }

    public struct Vout: Codable {
        public struct ScriptPubKey: Codable {
            public let asm: String
            
            public let hex: String

            public let reqSigs: Int

            public let type: String

            public let addresses: [String]
        }

        public let value: Double

        public let n: Int

        public let scriptPubKey: ScriptPubKey?
    }
}

public struct WitnessUTXO: Codable {
    public struct ScriptPubKey: Codable {
        public let asm: String

        public let hex: String
        
        public let type: String
        
        public let address: String
    }

    public let amount: Double

    public let scriptPubKey: ScriptPubKey
}
