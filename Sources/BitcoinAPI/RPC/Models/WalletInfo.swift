//
//  WalletInfo.swift
//  
//
//  Created by Davide De Rosa on 3/22/21.
//

import Foundation

public struct WalletInfo: Codable {
    public struct ScanningProgress: Codable {
        public let duration: Int

        public let progress: Double
    }
    
    enum CodingKeys: String, CodingKey {
        case walletName = "walletname"
        
        case walletVersion = "walletversion"

        case balance

        case unconfirmedBalance = "unconfirmed_balance"

        case immatureBalance = "immature_balance"

        case txCount = "txcount"
        
        case keypoolOldest = "keypoololdest"
        
        case keypoolSize = "keypoolsize"

        case keypoolSizeHDInternal = "keypoolsize_hd_internal"

        case payTxFee = "paytxfee"

        case privateKeysEnabled = "private_keys_enabled"

        case avoidReuse = "avoid_reuse"

        case scanning
    }

    public let walletName: String

    public let walletVersion: Int
        
    public let balance: Int
        
    public let unconfirmedBalance: Int
    
    public let immatureBalance: Int

    public let txCount: Int

    public let keypoolOldest: Int

    public let keypoolSize: Int

    public let keypoolSizeHDInternal: Int

    public let payTxFee: Int

    public let privateKeysEnabled: Bool

    public let avoidReuse: Bool

    public let scanning: ScanningProgress?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        walletName = try container.decode(String.self, forKey: .walletName)
        walletVersion = try container.decode(Int.self, forKey: .walletVersion)
        balance = try container.decode(Int.self, forKey: .balance)
        unconfirmedBalance = try container.decode(Int.self, forKey: .unconfirmedBalance)
        immatureBalance = try container.decode(Int.self, forKey: .immatureBalance)
        txCount = try container.decode(Int.self, forKey: .txCount)
        keypoolOldest = try container.decode(Int.self, forKey: .keypoolOldest)
        keypoolSize = try container.decode(Int.self, forKey: .keypoolSize)
        keypoolSizeHDInternal = try container.decode(Int.self, forKey: .keypoolSizeHDInternal)
        payTxFee = try container.decode(Int.self, forKey: .payTxFee)
        privateKeysEnabled = try container.decode(Bool.self, forKey: .privateKeysEnabled)
        avoidReuse = try container.decode(Bool.self, forKey: .avoidReuse)

        // all this boilerplate to work around malformed "scanning" field
        do {
            scanning = try container.decode(ScanningProgress.self, forKey: .scanning)
        } catch {
            scanning = nil
        }
    }
}
