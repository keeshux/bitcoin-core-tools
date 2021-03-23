//
//  NetworkInfo.swift
//
//
//  Created by Davide De Rosa on 2/17/21.
//

import Foundation

public struct NetworkInfo: Codable {
    enum CodingKeys: String, CodingKey {
        case version
        
        case subVersion = "subversion"
        
        case protocolVersion = "protocolversion"
    }
    
    public let version: Int

    public let subVersion: String
    
    public let protocolVersion: Int
}
