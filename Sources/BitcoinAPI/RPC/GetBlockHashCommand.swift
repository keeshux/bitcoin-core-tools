//
//  GetBlockHashCommand.swift
//
//
//  Created by Davide De Rosa on 2/17/21.
//

import Foundation
import JSONRPC

public struct GetBlockHashCommand: RPCCommand {
    public struct Response: RPCResponse {
        public let result: String?
        
        public let error: RPCError?
    }
    
    public let blockHeight: Int
    
    public init(blockHeight: Int) {
        self.blockHeight = blockHeight
    }
}

// MARK: RPCCommand

extension GetBlockHashCommand {
    public var method: String {
        return "getblockhash"
    }
    
    public var path: String? {
        return nil
    }

    public func argumentsData(withEncoder encoder: JSONEncoder) throws -> [Data] {
        return [try encoder.encode(blockHeight)]
    }

    public func responseObject(for data: Data, withDecoder decoder: JSONDecoder) throws -> Response {
        return try decoder.decode(Response.self, from: data)
    }
}
