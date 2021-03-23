//
//  ListTransactionsCommand.swift
//  
//
//  Created by Davide De Rosa on 3/9/21.
//

import Foundation
import JSONRPC

public struct ListTransactionsCommand: WalletCommand {
    public struct Response: RPCResponse {
        public let result: [WalletTransaction]?
        
        public let error: RPCError?
    }
    
    public var walletName: String
    
    public init(walletName: String) {
        self.walletName = walletName
    }
}

// MARK: RPCCommand

extension ListTransactionsCommand {
    public var method: String {
        return "listtransactions"
    }
    
    public func argumentsData(withEncoder encoder: JSONEncoder) throws -> [Data] {
        return []
    }
    
    public func responseObject(for data: Data, withDecoder decoder: JSONDecoder) throws -> Response {
        return try decoder.decode(Response.self, from: data)
    }
}
