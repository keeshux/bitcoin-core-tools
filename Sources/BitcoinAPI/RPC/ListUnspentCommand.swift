//
//  ListUnspentCommand.swift
//  
//
//  Created by Davide De Rosa on 3/9/21.
//

import Foundation
import JSONRPC

public struct ListUnspentCommand: WalletCommand {
    public struct Response: RPCResponse {
        public let result: [UTXO]?
        
        public let error: RPCError?
    }
    
    public var walletName: String
    
    public init(walletName: String) {
        self.walletName = walletName
    }
}

// MARK: RPCCommand

extension ListUnspentCommand {
    public var method: String {
        return "listunspent"
    }
    
    public func argumentsData(withEncoder encoder: JSONEncoder) throws -> [Data] {
        return []
    }
    
    public func responseObject(for data: Data, withDecoder decoder: JSONDecoder) throws -> Response {
        return try decoder.decode(Response.self, from: data)
    }
}
