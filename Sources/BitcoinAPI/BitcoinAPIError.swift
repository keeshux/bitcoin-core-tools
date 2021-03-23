//
//  BitcoinAPIError.swift
//  
//
//  Created by Davide De Rosa on 3/23/21.
//

import Foundation

public enum BitcoinAPIError: LocalizedError {
    case derivationMismatch
    
    // MARK: LocalizedError

    public var failureReason: String? {
        switch self {
        case .derivationMismatch:
            return "Addresses are not derived from provided descriptor"
        }
    }
}
