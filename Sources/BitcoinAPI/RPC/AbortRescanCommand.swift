//
//  AbortRescanCommand.swift
//  
//
//  Created by Davide De Rosa on 3/22/21.
//

import Foundation
import JSONRPC

public struct AbortRescanCommand: WalletCommand {
    public struct Response: RPCResponse {
        public let result: Bool?
        
        public let error: RPCError?
    }
    
    public var walletName: String
    
    public init(walletName: String) {
        self.walletName = walletName
    }
}

// MARK: RPCCommand

extension AbortRescanCommand {
    public var method: String {
        return "abortrescan"
    }
    
    public func argumentsData(withEncoder encoder: JSONEncoder) throws -> [Data] {
        return []
    }
    
    public func responseObject(for data: Data, withDecoder decoder: JSONDecoder) throws -> Response {
        return try decoder.decode(Response.self, from: data)
    }
}
