//
//  WalletCommand.swift
//  
//
//  Created by Davide De Rosa on 2/20/21.
//

import Foundation
import JSONRPC

public protocol WalletCommand: RPCCommand {
    var walletName: String { get }
}

extension WalletCommand {
    public var path: String? {
        return "/wallet/\(walletName)"
    }
}
