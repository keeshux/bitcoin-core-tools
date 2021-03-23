//
//  Transport.swift
//
//
//  Created by Davide De Rosa on 2/17/21.
//

import Foundation
import Combine

public protocol Transport {
    func writePublisher(_ request: URLRequest) -> AnyPublisher<Data, Error>
}
