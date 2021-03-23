//
//  WalletSingleKey.swift
//
//
//  Created by Davide De Rosa on 3/10/21.
//

import Foundation
import BitcoinTools

public struct WalletSingleKey: Identifiable, Codable {
    public let purpose: HDPurpose
    
    public let masterFingerprint: HDFingerprint

    public let derivationPath: HDDerivationPath

    public let xpub: XPUBKey

    public let externalAddresses: [String]?

    public var descriptorPair: DescriptorPair {
        return DescriptorPair(
            externalDescriptor: descriptor(from: masterFingerprint, purpose: purpose, isInternal: false),
            internalDescriptor: descriptor(from: masterFingerprint, purpose: purpose, isInternal: true)
        )
    }

    private func descriptor(from masterFingerprint: HDFingerprint, purpose: HDPurpose, isInternal: Bool) -> String {
        let key = HDSingleSignatureKey(
            descriptorType: purpose.descriptorType,
            derivationPath: derivationPath.withMasterFingerprint(masterFingerprint),
            xpub: xpub
        )
        return key.groupDescriptor(isInternal: isInternal)
    }

    // MARK: Identifiable
    
    public var id: String {
        return xpub.rawValue
    }
}
