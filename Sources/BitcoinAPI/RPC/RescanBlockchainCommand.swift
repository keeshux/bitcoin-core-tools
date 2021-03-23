//
//  RescanBlockchainCommand.swift
//  
//
//  Created by Davide De Rosa on 3/22/21.
//

import Foundation
import JSONRPC

public struct RescanBlockchainCommand: WalletCommand {
    public struct Response: RPCResponse {
        public let error: RPCError?
    }
    
    public let walletName: String
    
    public let startHeight: Int?
    
    public let stopHeight: Int?
    
    public init(walletName: String, startHeight: Int? = nil, stopHeight: Int? = nil) {
        self.walletName = walletName
        self.startHeight = startHeight
        self.stopHeight = stopHeight
    }
}

// MARK: RPCCommand

extension RescanBlockchainCommand {
    public var method: String {
        return "rescanblockchain"
    }
    
    public func argumentsData(withEncoder encoder: JSONEncoder) throws -> [Data] {
        guard let startHeight = startHeight else {
            return []
        }
        guard let stopHeight = stopHeight else {
            return [try encoder.encode(startHeight)]
        }
        return [
            try encoder.encode(startHeight),
            try encoder.encode(stopHeight)
        ]
    }
    
    public func responseObject(for data: Data, withDecoder decoder: JSONDecoder) throws -> Response {
        return try decoder.decode(Response.self, from: data)
    }
}
