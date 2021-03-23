//
//  Encoding+Digest.swift
//  
//
//  Created by Davide De Rosa on 2/20/21.
//

import Foundation
import CommonCrypto

extension Data {
    public var sha256: Data {
        var md = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        _ = withUnsafeBytes {
            CC_SHA256($0.baseAddress, CC_LONG(count), &md)
        }
        return Data(md)
    }
}
