//
//  HDDerivationPath.swift
//  
//
//  Created by Davide De Rosa on 2/21/21.
//

import Foundation

public struct HDDerivationPath: RawRepresentable, Equatable, Codable {
    public struct Component: RawRepresentable, Equatable, Codable {
        static let root = "m"

        static let hardenedSuffix = "'"

        public let account: UInt
        
        public let isHardened: Bool

        public init(_ account: UInt, _ isHardened: Bool) {
            self.account = account
            self.isHardened = isHardened
        }

        // MARK: RawRepresentable
        
        public var rawValue: String {
            return "\(account)\(isHardened ? Component.hardenedSuffix : "")"
        }
        
        public init?(rawValue: String) {
            var str = rawValue
            isHardened = str.hasSuffix(Component.hardenedSuffix)
            if isHardened {
                str.removeLast()
            }
            guard let account = UInt(str) else {
                return nil
            }
            self.account = account
        }
    }
    
    private static let rx = try! NSRegularExpression(pattern: "^(m|[0-9A-Fa-f]{8})(/([0-9]|[1-9][0-9]*)\(Component.hardenedSuffix)?)*$", options: [])
    
    public let nodes: [Component]
    
    public let masterFingerprint: HDFingerprint?
    
    public init(path: String) throws {
        guard let _ = HDDerivationPath.rx.firstMatch(in: path, options: [], range: NSMakeRange(0, path.count)) else {
            throw BitcoinToolsError.bip32Path
        }
        var components = path.components(separatedBy: "/")
        assert(!components.isEmpty)
        let root = components.first
        if root == Component.root {
            masterFingerprint = nil
        } else {
            masterFingerprint = HDFingerprint(rawValue: root!)
        }
        components.removeFirst()
        nodes = components.map { Component(rawValue: $0)! }
    }
    
    public init(nodes: [Component], masterFingerprint: HDFingerprint? = nil) {
        self.nodes = nodes
        self.masterFingerprint = masterFingerprint
    }

    public init(masterFingerprint: HDFingerprint, purpose: HDPurpose, network: Network, account: UInt) {
        self.masterFingerprint = masterFingerprint
        nodes = [
            Component(purpose.rawValue, true),
            Component(network.derivation, true),
            Component(account, true)
        ]
    }
    
    public func withMasterFingerprint(_ fingerprint: HDFingerprint) -> HDDerivationPath {
        return HDDerivationPath(nodes: nodes, masterFingerprint: fingerprint)
    }
    
    // MARK: RawRepresentable
    
    public init?(rawValue: String) {
        try? self.init(path: rawValue)
    }
    
    public var rawValue: String {
        var path = masterFingerprint?.rawValue ?? Component.root
        nodes.forEach {
            path.append("/\($0.rawValue)")
        }
        return path
    }
}

extension Network {
    public var derivation: UInt {
        switch self {
        case .mainnet:
            return 0
            
        case .testnet:
            return 1
        }
    }
}
