//
//  XPUBKey.swift
//  
//
//  Created by Davide De Rosa on 2/20/21.
//

import Foundation

public struct XPUBKey: RawRepresentable, Equatable, Codable {
    private enum Header: UInt32 {
        case xpub = 0x0488b21e
        
        case tpub = 0x043587cf
    }
    
    private let header: Header
    
    public var network: Network {
        switch header {
        case .xpub:
            return .mainnet
            
        case .tpub:
            return .testnet
        }
    }
    
    public let publicKey: Data

    public init(string: String) throws {
        guard let data = string.base58CheckData else {
            throw BitcoinToolsError.base58
        }
        guard data.count == 78 else {
            throw BitcoinToolsError.xpubSerializedLength
        }
        let headerValue = data.UInt32Value(from: 0).byteSwapped
        guard let header = Header(rawValue: headerValue) else {
            throw BitcoinToolsError.header
        }
        self.header = header
        publicKey = data[4..<data.count]
    }
    
    // MARK: RawRepresentable
    
    public var rawValue: String {
        var data = Data()
        data.append(header.rawValue.byteSwapped)
        data.append(publicKey)
        guard let string = data.base58CheckString else {
            fatalError(BitcoinToolsError.base58.localizedDescription)
        }
        return string
    }

    public init?(rawValue: String) {
        try? self.init(string: rawValue)
    }
}
