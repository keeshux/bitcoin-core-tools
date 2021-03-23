//
//  DeriveAddressesCommand.swift
//  
//
//  Created by Davide De Rosa on 3/7/21.
//

import Foundation
import JSONRPC

public struct DeriveAddressesCommand: RPCCommand {
    public struct Response: RPCResponse {
        public let result: [String]?
        
        public let error: RPCError?
    }
    
    public let descriptor: String
    
    public let range: ClosedRange<Int>
    
    public init(descriptor: String, range: ClosedRange<Int>) {
        self.descriptor = descriptor
        self.range = range
    }
}

// MARK: RPCCommand

extension DeriveAddressesCommand {
    public var method: String {
        return "deriveaddresses"
    }
    
    public var path: String? {
        return nil
    }

    public func argumentsData(withEncoder encoder: JSONEncoder) throws -> [Data] {
        return [
            try encoder.encode(descriptor),
            try encoder.encode([range.first, range.last])
        ]
    }
    
    public func responseObject(for data: Data, withDecoder decoder: JSONDecoder) throws -> Response {
        return try decoder.decode(Response.self, from: data)
    }
}
