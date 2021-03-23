//
//  ImportMultiCommand.swift
//  
//
//  Created by Davide De Rosa on 3/6/21.
//

import Foundation
import JSONRPC

public struct ImportMultiCommand: WalletCommand {
    public struct Response: RPCResponse {
        public struct SingleResponse: Codable {
            public let success: Bool
            
            public let error: RPCError?
        }

        public let result: [SingleResponse]
        
        public let error: RPCError?
    }
    
    public let walletName: String
    
    public let descriptors: [(String, Bool)]
    
    public let range: ClosedRange<Int>
    
    public let timestamp: Int?
    
    public let rescan: Bool
    
    public init(
        walletName: String,
        descriptors: [(String, Bool)],
        range: ClosedRange<Int> = 0...1000,
        timestamp: Int? = nil,
        rescan: Bool = true
    ) {
        self.walletName = walletName
        self.descriptors = descriptors
        self.range = range
        self.timestamp = timestamp
        self.rescan = rescan
    }
}

// MARK: RPCCommand

extension ImportMultiCommand {
    public var method: String {
        return "importmulti"
    }
    
    public func argumentsData(withEncoder encoder: JSONEncoder) throws -> [Data] {
        let imported = descriptors.map {
            ImportDescriptor(
                desc: $0.0,
                range: range,
                timestamp: timestamp,
                isKeypool: true,
                isWatchOnly: true,
                isInternal: $0.1
            )
        }
        return [
            try encoder.encode(imported),
            try encoder.encode(["rescan": rescan])
        ]
    }
    
    public func responseObject(for data: Data, withDecoder decoder: JSONDecoder) throws -> Response {
        return try decoder.decode(Response.self, from: data)
    }
}

private struct ImportDescriptor: Codable {
    enum CodingKeys: String, CodingKey {
        case desc
        
        case range
        
        case timestamp
        
        case isKeypool = "keypool"

        case isWatchOnly = "watchonly"

        case isInternal = "internal"
    }
    
    let desc: String
    
    let range: ClosedRange<Int>
    
    let timestamp: Int?
    
    let isKeypool: Bool
    
    let isWatchOnly: Bool
    
    let isInternal: Bool
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(desc, forKey: .desc)
        try container.encode([range.first, range.last], forKey: .range)
        if let timestamp = timestamp {
            try container.encode(timestamp, forKey: .timestamp)
        } else {
            try container.encode("now", forKey: .timestamp)
        }
        try container.encode(isKeypool, forKey: .isKeypool)
        try container.encode(isWatchOnly, forKey: .isWatchOnly)
        try container.encode(isInternal, forKey: .isInternal)
    }
}
