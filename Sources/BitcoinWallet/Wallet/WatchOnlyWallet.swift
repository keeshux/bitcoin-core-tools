//
//  WatchOnlyWallet.swift
//  
//
//  Created by Davide De Rosa on 2/20/21.
//

import Foundation

public struct WatchOnlyWallet {
    public let name: String
    
    public let device: WalletDevice
    
    public init(name: String, device: WalletDevice) {
        self.name = name
        self.device = device
    }
}
