//
//  AddressInfo.swift
//  
//
//  Created by Davide De Rosa on 3/22/21.
//

import Foundation

public struct AddressInfo: Codable {
    public struct Embedded: Codable {
        enum CodingKeys: String, CodingKey {
            case address

            case scriptPubKey

            case desc

            case isScript = "isscript"

            case isWitness = "iswitness"

            case witnessVersion = "witness_version"

            case witnessProgram = "witness_program"
            
            case script
            
            case hex

            case pubKey = "pubkey"
        }

        public let address: String

        public let scriptPubKey: String

        public let desc: String?

        public let isScript: Bool

        public let isWitness: Bool

        public let witnessVersion: Int?

        public let witnessProgram: String?

        public let script: String?
        
        public let hex: String?

        public let pubKey: String
    }

    enum CodingKeys: String, CodingKey {
        case address

        case scriptPubKey

        case isMine = "ismine"

        case solvable

        case desc

        case isWatchOnly = "iswatchonly"

        case isScript = "isscript"

        case isWitness = "iswitness"

        case witnessVersion = "witness_version"

        case witnessProgram = "witness_program"

        case script
        
        case hex

        case pubKey = "pubkey"

        case isChange = "ischange"

        case timestamp

        case hdKeypath = "hdkeypath"

        case hdSeedId = "hdseedid"

        case hdMasterFingerprint = "hdmasterfingerprint"

//        case labels
        
        case embedded
    }

    public let address: String

    public let scriptPubKey: String

    public let isMine: Bool

    public let solvable: Bool

    public let desc: String?

    public let isWatchOnly: Bool

    public let isScript: Bool

    public let isWitness: Bool

    public let witnessVersion: Int?

    public let witnessProgram: String?
    
    public let script: String?
    
    public let hex: String?

    public let pubKey: String?

    public let isChange: Bool

    public let timestamp: Int?

    public let hdKeypath: String?

    public let hdSeedId: String?

    public let hdMasterFingerprint: String?

//    public let labels: [String]

    public let embedded: Embedded?
}
