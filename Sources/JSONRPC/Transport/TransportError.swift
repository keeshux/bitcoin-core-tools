//
//  TransportError.swift
//  
//
//  Created by Davide De Rosa on 3/23/21.
//

import Foundation

public enum TransportError: LocalizedError {
    case unauthorized
    
    public var failureReason: String? {
        switch self {
        case .unauthorized:
            return "Bad credentials"
        }
    }
}
