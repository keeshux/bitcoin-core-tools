//
//  ClearTransport.swift
//
//
//  Created by Davide De Rosa on 2/18/21.
//

import Foundation
import Combine

public class ClearTransport: Transport {
    private var cancellables: Set<AnyCancellable>
    
    public init() {
        cancellables = []
    }

    public func writePublisher(_ request: URLRequest) -> AnyPublisher<Data, Error> {
        URLSession(configuration: .ephemeral).dataTaskPublisher(for: request)
            .tryMap { result in
                if let response = result.response as? HTTPURLResponse {
                    JSONRPC.logger.debug("RPC -> HTTP \(response.statusCode)")
                    if let bodyString = String(data: result.data, encoding: .utf8), !bodyString.isEmpty {
                        JSONRPC.logger.debug("RPC -> \(bodyString)")
                    }
                    switch response.statusCode {
                    case 401:
                        throw TransportError.unauthorized

                    default:
//                        guard response.statusCode < 300 else {
//                            completionHandler(result.data, TransportError.unknown)
//                            return
//                        }
                        break
                    }
                }
                return result.data
            }.eraseToAnyPublisher()
    }
}
