//
//  Encoding+Base58.swift
//  
//
//  Created by Davide De Rosa on 2/20/21.
//

import Foundation
import libbase58
import CommonCrypto

private func setSHA256Implementation() {
    b58_sha256_impl = localSHA256
}

private func localSHA256(_ digest: UnsafeMutableRawPointer?, _ data: UnsafeRawPointer?, _ size: Int) -> Bool {
    return CC_SHA256(data, CC_LONG(size), digest?.assumingMemoryBound(to: UInt8.self)) != nil
}

extension Data {
    public var base58CheckString: String? {
        setSHA256Implementation()
        let decoded = self
        let decodedSize = count
        var encoded = Data(repeating: 0, count: decodedSize * 2)
        var encodedSize = encoded.count
        let success = decoded.withUnsafeBytes { (decodedBytes: UnsafeRawBufferPointer) -> Bool in
            return encoded.withUnsafeMutableBytes { (encodedBytes: UnsafeMutableRawBufferPointer) -> Bool in
                return b58check_enc(
                    encodedBytes.bindMemory(to: Int8.self).baseAddress,
                    &encodedSize,
                    decodedBytes.baseAddress,
                    decodedSize
                )
            }
        }
        guard success else {
            return nil
        }
        encoded.count = encodedSize - 1
        return String(data: encoded, encoding: .utf8)
    }
}

extension String {
    public var base58CheckData: Data? {
        setSHA256Implementation()
        guard let encoded = data(using: .utf8) else {
            return nil
        }
        let encodedSize = encoded.count
        var decoded = [UInt8](repeating: 0, count: encoded.count)
        var decodedSize = decoded.count
        let success = encoded.withUnsafeBytes { (encodedBytes: UnsafeRawBufferPointer) -> Bool in
            let encodedPointer = encodedBytes.bindMemory(to: Int8.self).baseAddress
            guard b58tobin(&decoded, &decodedSize, encodedPointer, encodedSize) else {
                return false
            }
            decoded = Array(decoded[(decoded.count - decodedSize)..<decoded.count])
            return b58check(decoded, decodedSize, encodedPointer, encodedSize) == 0
        }
        guard success else {
            return nil
        }
        return Data(decoded[0..<(decoded.count - 4)])
    }
}
