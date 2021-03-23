//
//  WalletDevice.swift
//  
//
//  Created by Davide De Rosa on 3/10/21.
//

import Foundation
import BitcoinTools

public protocol WalletDevice: CustomStringConvertible {
    var network: Network { get }
    
    var fingerprint: HDFingerprint { get }
    
    var purposes: [HDPurpose] { get }
    
    func singleKey(forPurpose purpose: HDPurpose) -> WalletSingleKey
}

extension WalletDevice {
    public var singleKeys: [WalletSingleKey] {
        return purposes.map {
            return singleKey(forPurpose: $0)
        }
    }
}
