//
//  RPCCommand.swift
//
//
//  Created by Davide De Rosa on 2/17/21.
//

import Foundation
import Combine
import Logging

public protocol RPCCommand {
    associatedtype R: RPCResponse
    
    var method: String { get }
    
    var path: String? { get }
    
    func argumentsData(withEncoder encoder: JSONEncoder) throws -> [Data]
    
    func responseObject(for data: Data, withDecoder decoder: JSONDecoder) throws -> R
}

extension RPCCommand {
    public func executePublisher(_ rpc: RPC, timeout: TimeInterval = 0.0) -> AnyPublisher<R, Error> {
        let arguments: [Data]
        do {
            arguments = try argumentsData(withEncoder: JSONEncoder())
        } catch let e {
            return Fail<R, Error>(error: e)
                .eraseToAnyPublisher()
        }
        return rpc.executePublisher(method, path: path, arguments: arguments, timeout: timeout)
            .tryMap { (data: Data) -> R in
                do {
                    let resp = try responseObject(for: data, withDecoder: JSONDecoder())
                    JSONRPC.logger.debug("RPC -> \(resp)")
                    if let error = resp.error {
                        throw error
                    }
                    return resp
                } catch let e {
                    JSONRPC.logger.error("RPC -> (parsing): \(e)")
                    throw e
                }
            }.handleEvents(receiveCompletion: {
                switch $0 {
                case .finished:
                    break
                    
                case .failure(let error):
                    JSONRPC.logger.error("RPC -> (empty): \(error)")
                }
            }).eraseToAnyPublisher()
    }
}
