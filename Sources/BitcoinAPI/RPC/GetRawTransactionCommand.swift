//
//  GetRawTransactionCommand.swift
//
//
//  Created by Davide De Rosa on 2/18/21.
//

import Foundation
import JSONRPC

public struct GetRawTransactionCommand: RPCCommand {
    public struct Response: RPCResponse {
        public let result: Transaction?
        
        public let error: RPCError?
    }
    
    public let txid: String
    
    public init(txid: String) {
        self.txid = txid
    }
}

// MARK: RPCCommand

extension GetRawTransactionCommand {
    public var method: String {
        return "getrawtransaction"
    }
    
    public var path: String? {
        return nil
    }
    
    public func argumentsData(withEncoder encoder: JSONEncoder) throws -> [Data] {
        return [try encoder.encode(txid)]
    }

    public func responseObject(for data: Data, withDecoder decoder: JSONDecoder) throws -> Response {
        return try decoder.decode(Response.self, from: data)
    }
}
