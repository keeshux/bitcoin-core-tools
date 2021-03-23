//
//  String+BitcoinAPI.swift
//  
//
//  Created by Davide De Rosa on 3/23/21.
//

import Foundation

extension String {
    public func asHash256() throws -> Hash256 {
        return try Hash256(string: self)
    }

    public func asHDDerivationPath() throws -> HDDerivationPath {
        return try HDDerivationPath(path: self)
    }

    public func asHDFingerprint() throws -> HDFingerprint {
        return try HDFingerprint(hex: self)
    }

    public func asLegacyAddress() throws -> LegacyAddress {
        return try LegacyAddress(string: self)
    }

    public func asSegwitAddress() throws -> SegwitAddress {
        return try SegwitAddress(string: self)
    }

    public func asXPUBKey() throws -> XPUBKey {
        return try XPUBKey(string: self)
    }
}
