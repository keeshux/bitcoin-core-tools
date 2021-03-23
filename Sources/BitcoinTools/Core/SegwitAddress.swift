//
//  SegwitAddress.swift
//  
//
//  Created by Davide De Rosa on 2/21/21.
//

import Foundation
@testable import Bech32

// text: bc or tb
//
// data:
//  1-byte version
//  one of:
//      20-byte hash160 P2PWKH
//      32-byte hash160 P2WSH
//
// Bech32-encoded

private let coder = SegwitAddrCoder()

public struct SegwitAddress: RawRepresentable, Equatable, Codable {
    public let network: Network
    
    public let version: UInt8
    
    public let descriptorType: DescriptorType
    
    public let program: Data

    public init(string: String) throws {
        guard string.count >= 2 else {
            throw BitcoinToolsError.segwit
        }
        let hrpValue = string[..<string.index(string.startIndex, offsetBy: 2)]
        guard let hrp = Bech32.HRP(rawValue: String(hrpValue)) else {
            throw BitcoinToolsError.segwit
        }
        let pair = try coder.decode(hrp: hrp.rawValue, addr: string)
        network = hrp.network
        version = UInt8(pair.version)
        program = pair.program
        switch program.count {
        case 20:
            descriptorType = .wpkh
            
        case 32:
            descriptorType = .wsh

        default:
            throw BitcoinToolsError.segwit
        }
    }

    // MARK: RawRepresentable
    
    public var rawValue: String {
        do {
            return try coder.encode(hrp: network.hrp.rawValue, version: Int(version), program: program)
        } catch let e {
            fatalError(e.localizedDescription)
        }
    }

    public init?(rawValue: String) {
        try? self.init(string: rawValue)
    }
}
