//
//  GetAddressInfoCommand.swift
//  
//
//  Created by Davide De Rosa on 3/22/21.
//

import Foundation
import JSONRPC

public struct GetAddressInfoCommand: WalletCommand {
    public struct Response: RPCResponse {
        public let result: AddressInfo?
        
        public let error: RPCError?
    }
    
    public let walletName: String
    
    public let address: String
    
    public init(walletName: String, address: String) {
        self.walletName = walletName
        self.address = address
    }
}

// MARK: RPCCommand

extension GetAddressInfoCommand {
    public var method: String {
        return "getaddressinfo"
    }
    
    public func argumentsData(withEncoder encoder: JSONEncoder) throws -> [Data] {
        return [try encoder.encode(address)]
    }
    
    public func responseObject(for data: Data, withDecoder decoder: JSONDecoder) throws -> Response {
        return try decoder.decode(Response.self, from: data)
    }
}
