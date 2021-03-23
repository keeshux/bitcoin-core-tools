//
//  DescriptorPair.swift
//  
//
//  Created by Davide De Rosa on 3/6/21.
//

import Foundation

public struct DescriptorPair {
    public let externalDescriptor: String

    public let internalDescriptor: String
    
    public init(externalDescriptor: String, internalDescriptor: String) {
        self.externalDescriptor = externalDescriptor
        self.internalDescriptor = internalDescriptor
    }
}
