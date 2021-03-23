//
//  HDSingleSignatureKey.swift
//  
//
//  Created by Davide De Rosa on 2/20/21.
//

import Foundation

public struct HDSingleSignatureKey: Codable {
    public let descriptorType: DescriptorType

    public let derivationPath: HDDerivationPath

    public let xpub: XPUBKey
    
    public init(
        descriptorType: DescriptorType,
        derivationPath: HDDerivationPath,
        xpub: XPUBKey
    ) {
        switch descriptorType {
        case .wsh:
//            preconditionFailure("Use HDMultipleSignatureKey for P2WSH")
            preconditionFailure("Unsupported multisig")

        default:
            break
        }
        self.descriptorType = descriptorType
        self.derivationPath = derivationPath
        self.xpub = xpub
    }

    public func groupDescriptor(isInternal: Bool) -> String {
        let derivation = derivationPath.rawValue.replacingOccurrences(of: HDDerivationPath.Component.hardenedSuffix, with: "h")
        let path = "[\(derivation)]\(xpub.rawValue)/\(isInternal ? 1 : 0)/*"
        switch descriptorType {
        case .shWpkh:
            return "sh(wpkh(\(path)))"
            
        default:
            return "\(descriptorType.rawValue)(\(path))"
        }
    }
}
