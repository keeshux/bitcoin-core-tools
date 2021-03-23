//
//  Encoding+Hex.swift
//  
//
//  Created by Davide De Rosa on 2/20/21.
//

import Foundation

extension String {
    public var hexData: Data? {
        return Data(hex: self)
    }
}

extension Data {
    public var hexString: String {
        return toHex()
    }
}
