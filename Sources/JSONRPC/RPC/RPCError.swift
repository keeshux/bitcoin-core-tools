//
//  RPCError.swift
//
//
//  Created by Davide De Rosa on 2/18/21.
//

import Foundation

public struct RPCError: Error, Codable, LocalizedError {
    public let code: Int
    
    public let message: String

    public init(_ code: Int, _ message: String) {
        self.code = code
        self.message = message
    }
    
    // MARK: LocalizedError
    
    public var failureReason: String? {
        return message
    }
}
