//
//  GetTransactionCommand.swift
//  
//
//  Created by Davide De Rosa on 3/9/21.
//

import Foundation
import JSONRPC

public struct GetTransactionCommand: WalletCommand {
    public struct Response: RPCResponse {
        public let result: WalletTransaction?
        
        public let error: RPCError?
    }
    
    public let walletName: String
    
    public let txid: String
    
    public init(walletName: String, txid: String) {
        self.walletName = walletName
        self.txid = txid
    }
}

// MARK: RPCCommand

extension GetTransactionCommand {
    public var method: String {
        return "gettransaction"
    }
    
    public func argumentsData(withEncoder encoder: JSONEncoder) throws -> [Data] {
        return [try encoder.encode(txid)]
    }

    public func responseObject(for data: Data, withDecoder decoder: JSONDecoder) throws -> Response {
        return try decoder.decode(Response.self, from: data)
    }
}
