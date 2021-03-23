//
//  GetNetworkInfoCommand.swift
//  
//
//  Created by Davide De Rosa on 3/6/21.
//

import Foundation
import JSONRPC

public struct GetNetworkInfoCommand: RPCCommand {
    public struct Response: RPCResponse {
        public let result: NetworkInfo?
        
        public let error: RPCError?
    }
    
    public init() {
    }
}

// MARK: RPCCommand

extension GetNetworkInfoCommand {
    public var method: String {
        return "getnetworkinfo"
    }
    
    public var path: String? {
        return nil
    }

    public func argumentsData(withEncoder encoder: JSONEncoder) throws -> [Data] {
        return []
    }
    
    public func responseObject(for data: Data, withDecoder decoder: JSONDecoder) throws -> Response {
        return try decoder.decode(Response.self, from: data)
    }
}
