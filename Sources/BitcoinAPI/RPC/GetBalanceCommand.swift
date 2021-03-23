//
//  GetBalanceCommand.swift
//  
//
//  Created by Davide De Rosa on 2/20/21.
//

import Foundation
import JSONRPC

public struct GetBalanceCommand: WalletCommand {
    public struct Response: RPCResponse {
        public let result: Double?
        
        public let error: RPCError?
    }
    
    public let walletName: String
    
    public init(walletName: String) {
        self.walletName = walletName
    }
}

// MARK: RPCCommand

extension GetBalanceCommand {
    public var method: String {
        return "getbalance"
    }
    
    public func argumentsData(withEncoder encoder: JSONEncoder) throws -> [Data] {
        return []
    }
    
    public func responseObject(for data: Data, withDecoder decoder: JSONDecoder) throws -> Response {
        return try decoder.decode(Response.self, from: data)
    }
}
