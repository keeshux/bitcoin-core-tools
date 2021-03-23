//
//  HDFingerprint.swift
//  
//
//  Created by Davide De Rosa on 2/20/21.
//

import Foundation

public struct HDFingerprint: RawRepresentable, Identifiable, Equatable, Codable {
    public let hex: String
    
    public init(hex: String) throws {
        guard hex.count == 8 else {
            throw BitcoinToolsError.bip32Fingerprint
        }
        guard let data = hex.hexData else {
            throw BitcoinToolsError.bip32Fingerprint
        }
        guard data.count == 4 else {
            throw BitcoinToolsError.bip32Fingerprint
        }
        self.hex = hex
    }

    // MARK: RawRepresentable
    
    public var rawValue: String {
        return hex
    }
    
    public init?(rawValue: String) {
        try? self.init(hex: rawValue)
    }

    // MARK: Identifiable
    
    public var id: String {
        return rawValue
    }
}
