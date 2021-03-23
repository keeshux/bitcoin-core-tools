//
//  DecodePSBTCommand.swift
//  
//
//  Created by Davide De Rosa on 3/9/21.
//

import Foundation
import JSONRPC

public struct DecodePSBTCommand: RPCCommand {
    public struct Response: RPCResponse {
        public struct Result: Codable {
            public let tx: Transaction
        }

        public let result: Result?
        
        public let error: RPCError?
    }
    
    public let psbt: Data

    public init?(psbtString: String) {
        guard let psbt = Data(base64Encoded: psbtString) else {
            return nil
        }
        self.init(psbt: psbt)
    }

    public init(psbt: Data) {
        self.psbt = psbt
    }
}

// MARK: RPCCommand

extension DecodePSBTCommand {
    public var method: String {
        return "decodepsbt"
    }
    
    public var path: String? {
        return nil
    }

    public func argumentsData(withEncoder encoder: JSONEncoder) throws -> [Data] {
        return [
            try encoder.encode(psbt.base64EncodedString())
        ]
    }
    
    public func responseObject(for data: Data, withDecoder decoder: JSONDecoder) throws -> Response {
        return try decoder.decode(Response.self, from: data)
    }
}
