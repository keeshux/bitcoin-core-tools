//
//  HDPurpose.swift
//  
//
//  Created by Davide De Rosa on 2/20/21.
//

import Foundation

public enum HDPurpose: UInt, Identifiable, Codable {
    case bip44 = 44

    case bip49 = 49

    case bip84 = 84
    
    public var descriptorType: DescriptorType {
        switch self {
        case .bip44:
            return .pkh
            
        case .bip49:
            return .shWpkh
            
        case .bip84:
            return .wpkh
        }
    }

    // MARK: Identifiable

    public var id: UInt {
        return rawValue
    }
}
