//
//  GetBlockCommand.swift
//
//
//  Created by Davide De Rosa on 2/17/21.
//

import Foundation
import JSONRPC

public struct GetBlockCommand: RPCCommand {
    public struct Response: RPCResponse {
        public let result: Block?
        
        public let error: RPCError?
    }
    
    public let blockId: String
    
    public init(blockId: String) {
        self.blockId = blockId
    }
}

// MARK: RPCCommand

extension GetBlockCommand {
    public var method: String {
        return "getblock"
    }
    
    public var path: String? {
        return nil
    }

    public func argumentsData(withEncoder encoder: JSONEncoder) throws -> [Data] {
        return [try encoder.encode(blockId)]
    }
    
    public func responseObject(for data: Data, withDecoder decoder: JSONDecoder) throws -> Response {
        return try decoder.decode(Response.self, from: data)
    }
}
