//
//  LegacyAddress.swift
//  
//
//  Created by Davide De Rosa on 2/21/21.
//

import Foundation

// 1-byte version
// 20-byte hash160
// 4-byte checksum
//
// Base58-encoded

public struct LegacyAddress: RawRepresentable, Equatable, Codable {
    enum Version: UInt8 {
        case mainPKH = 0x00

        case mainSH = 0x05

        case testPKH = 0x6f

        case testSH = 0xc4
    }
    
    public let network: Network
    
    public let descriptorType: DescriptorType
    
    public let hash160: Data

    public init(string: String) throws {
        guard let data = string.base58CheckData, data.count == 21 else {
            throw BitcoinToolsError.base58
        }
        guard let versionValue = data.first, let version = Version(rawValue: versionValue) else {
            throw BitcoinToolsError.header
        }
        switch version {
        case .mainPKH:
            network = .mainnet
            descriptorType = .pkh
            
        case .mainSH:
            network = .mainnet
            descriptorType = .shWpkh
            
        case .testPKH:
            network = .testnet
            descriptorType = .pkh

        case .testSH:
            network = .testnet
            descriptorType = .shWpkh
        }
        hash160 = data[1..<data.count]
    }

    // MARK: RawRepresentable

    public var rawValue: String {
        var data = Data()
        switch network {
        case .mainnet:
            switch descriptorType {
            case .pkh:
                data.append(Version.mainPKH.rawValue)
                
            case .shWpkh:
                data.append(Version.mainSH.rawValue)

            default:
                assertionFailure()
            }

        case .testnet:
            switch descriptorType {
            case .pkh:
                data.append(Version.testPKH.rawValue)
                
            case .shWpkh:
                data.append(Version.testSH.rawValue)

            default:
                assertionFailure()
            }
        }
        data.append(hash160)
        guard let string = data.base58CheckString else {
            fatalError(BitcoinToolsError.base58.localizedDescription)
        }
        return string
    }

    public init?(rawValue: String) {
        try? self.init(string: rawValue)
    }
}
