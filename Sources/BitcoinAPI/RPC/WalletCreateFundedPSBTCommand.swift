//
//  WalletCreateFundedPSBTCommand.swift
//  
//
//  Created by Davide De Rosa on 3/9/21.
//

import Foundation
import JSONRPC

public struct WalletCreateFundedPSBTCommand: WalletCommand {
    public struct Response: RPCResponse {
        public struct Result: Codable {
            public let psbt: Data

            public let fee: Double

            public let changepos: Int
        }

        public let result: Result?
        
        public let error: RPCError?
    }

    public struct Options: Codable {
        public let includeWatching: Bool
        
        public let feeRate: Int?
        
        public let replaceable: Bool
        
        public init(
            includeWatching: Bool = false,
            feeRate: Int? = nil,
            replaceable: Bool = false
        ) {
            self.includeWatching = includeWatching
            self.feeRate = feeRate
            self.replaceable = replaceable
        }
    }
    
    public let walletName: String

    public let inputs: [Transaction.Vin]
    
    public let outputs: [String: Double]
    
    public let locktime: Int
    
    public let options: Options?
    
    public let bip32derivs: Bool

    public init(
        walletName: String,
        inputs: [Transaction.Vin] = [],
        outputs: [String: Double],
        locktime: Int = 0,
        options: Options? = nil,
        bip32derivs: Bool = false
    ) {
        self.walletName = walletName
        self.inputs = inputs
        self.outputs = outputs
        self.locktime = locktime
        self.options = options
        self.bip32derivs = bip32derivs
    }
}

// MARK: RPCCommand

extension WalletCreateFundedPSBTCommand {
    public var method: String {
        return "walletcreatefundedpsbt"
    }
    
    public func argumentsData(withEncoder encoder: JSONEncoder) throws -> [Data] {
        return [
            try encoder.encode(inputs),
            try encoder.encode(outputs),
            try encoder.encode(locktime),
            try encoder.encode(options)
        ]
    }
    
    public func responseObject(for data: Data, withDecoder decoder: JSONDecoder) throws -> Response {
        return try decoder.decode(Response.self, from: data)
    }
}
