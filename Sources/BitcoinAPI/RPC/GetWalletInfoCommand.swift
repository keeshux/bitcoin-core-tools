//
//  GetWalletInfoCommand.swift
//  
//
//  Created by Davide De Rosa on 3/22/21.
//

import Foundation
import JSONRPC

public struct GetWalletInfoCommand: WalletCommand {
    public struct Response: RPCResponse {
        public let result: WalletInfo?
        
        public let error: RPCError?
    }
    
    public let walletName: String
    
    public init(walletName: String) {
        self.walletName = walletName
    }
}

// MARK: RPCCommand

extension GetWalletInfoCommand {
    public var method: String {
        return "getwalletinfo"
    }
    
    public func argumentsData(withEncoder encoder: JSONEncoder) throws -> [Data] {
        return []
    }
    
    public func responseObject(for data: Data, withDecoder decoder: JSONDecoder) throws -> Response {
        return try decoder.decode(Response.self, from: data)
    }
}
