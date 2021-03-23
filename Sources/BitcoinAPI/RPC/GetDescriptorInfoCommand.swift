//
//  GetDescriptorInfoCommand.swift
//  
//
//  Created by Davide De Rosa on 3/6/21.
//

import Foundation
import JSONRPC

public struct GetDescriptorInfoCommand: RPCCommand {
    public struct Response: RPCResponse {
        public let result: DescriptorInfo?
        
        public let error: RPCError?
    }
    
    public let descriptor: String
    
    public init(descriptor: String) {
        self.descriptor = descriptor
    }
}

// MARK: RPCCommand

extension GetDescriptorInfoCommand {
    public var method: String {
        return "getdescriptorinfo"
    }
    
    public var path: String? {
        return nil
    }

    public func argumentsData(withEncoder encoder: JSONEncoder) throws -> [Data] {
        return [try encoder.encode(descriptor)]
    }
    
    public func responseObject(for data: Data, withDecoder decoder: JSONDecoder) throws -> Response {
        return try decoder.decode(Response.self, from: data)
    }
}
