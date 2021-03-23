//
//  LoadWalletCommand.swift
//  
//
//  Created by Davide De Rosa on 3/7/21.
//

import Foundation
import JSONRPC

public struct LoadWalletCommand: RPCCommand {
    public struct Response: RPCResponse {
        public let result: WalletResult?
        
        public let error: RPCError?
    }
    
    public let walletName: String
    
    public init(walletName: String) {
        self.walletName = walletName
    }
}

// MARK: RPCCommand

extension LoadWalletCommand {
    public var method: String {
        return "loadwallet"
    }
    
    public var path: String? {
        return nil
    }
    
    public func argumentsData(withEncoder encoder: JSONEncoder) throws -> [Data] {
        return [try encoder.encode(walletName)]
    }
    
    public func responseObject(for data: Data, withDecoder decoder: JSONDecoder) throws -> Response {
        return try decoder.decode(Response.self, from: data)
    }
}
