//
//  RPCResponse.swift
//
//
//  Created by Davide De Rosa on 2/18/21.
//

import Foundation

public protocol RPCResponse: Codable {
    var error: RPCError? { get }
}
