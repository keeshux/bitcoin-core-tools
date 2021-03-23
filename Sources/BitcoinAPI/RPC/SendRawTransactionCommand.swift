//
//  SendRawTransactionCommand.swift
//  
//
//  Created by Davide De Rosa on 3/9/21.
//

import Foundation
import JSONRPC

public struct SendRawTransactionCommand: RPCCommand {
    public struct Response: RPCResponse {
        public struct Result: Codable {
            public let hex: String
        }
        
        public let result: Result?
        
        public let error: RPCError?
    }
    
    public let hex: String
    
    public init(hex: String) {
        self.hex = hex
    }
}

// MARK: RPCCommand

extension SendRawTransactionCommand {
    public var method: String {
        return "sendrawtransaction"
    }
    
    public var path: String? {
        return nil
    }
    
    public func argumentsData(withEncoder encoder: JSONEncoder) throws -> [Data] {
        return [try encoder.encode(hex)]
    }

    public func responseObject(for data: Data, withDecoder decoder: JSONDecoder) throws -> Response {
        return try decoder.decode(Response.self, from: data)
    }
}
