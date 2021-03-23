//
//  DecodeRawTransactionCommand.swift
//  
//
//  Created by Davide De Rosa on 3/9/21.
//

import Foundation
import JSONRPC

public struct DecodeRawTransactionCommand: RPCCommand {
    public struct Response: RPCResponse {
        public let result: Transaction?
        
        public let error: RPCError?
    }
    
    public let hex: String

    public init(hex: String) {
        self.hex = hex
    }
}

// MARK: RPCCommand

extension DecodeRawTransactionCommand {
    public var method: String {
        return "decoderawtransaction"
    }
    
    public var path: String? {
        return nil
    }

    public func argumentsData(withEncoder encoder: JSONEncoder) throws -> [Data] {
        return [
            try encoder.encode(hex)
        ]
    }
    
    public func responseObject(for data: Data, withDecoder decoder: JSONDecoder) throws -> Response {
        return try decoder.decode(Response.self, from: data)
    }
}
