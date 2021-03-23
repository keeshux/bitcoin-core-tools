//
//  Hash256.swift
//  
//
//  Created by Davide De Rosa on 2/20/21.
//

import Foundation

public struct Hash256: RawRepresentable, Equatable, Hashable, Codable {
    public let string: String

    public init(string: String) throws {
        guard string.count == 64 else {
            throw BitcoinToolsError.hash256
        }
        guard let data = string.hexData else {
            throw BitcoinToolsError.hash256
        }
        guard data.count == 32 else {
            throw BitcoinToolsError.hash256
        }
        self.string = string
    }
    
    // MARK: RawRepresentable
    
    public var rawValue: String {
        return string
    }

    public init?(rawValue: String) {
        try? self.init(string: rawValue)
    }
}
