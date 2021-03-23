//
//  BitcoinAPI+Publishers.swift
//  
//
//  Created by Davide De Rosa on 3/7/21.
//

import Combine
import JSONRPC

extension BitcoinAPI {
    public static func descriptorWithChecksumPublisher(_ rpc: RPC, fromDescriptor desc: String) -> AnyPublisher<String, Error> {
        GetDescriptorInfoCommand(descriptor: desc).executePublisher(rpc)
            .map {
                "\(desc)#\($0.result!.checksum)"
            }.eraseToAnyPublisher()
    }
    
    public static func derivedAddressesPublisher(_ rpc: RPC, fromDescriptor desc: String, range: ClosedRange<Int>) -> AnyPublisher<[String], Error> {
        descriptorWithChecksumPublisher(rpc, fromDescriptor: desc)
            .flatMap {
                DeriveAddressesCommand(descriptor: $0, range: range).executePublisher(rpc)
            }.map {
                $0.result!
            }.eraseToAnyPublisher()
    }

    public static func verifyAddressesPublisher(_ rpc: RPC, descriptor: String, firstAddresses: [String]) -> AnyPublisher<Void, Error> {
        guard !firstAddresses.isEmpty else {
            return Empty()
                .eraseToAnyPublisher()
        }
        let range = 0...(firstAddresses.count - 1)
        return derivedAddressesPublisher(rpc, fromDescriptor: descriptor, range: range)
            .tryMap {
                guard firstAddresses.elementsEqual($0) else {
                    throw BitcoinAPIError.derivationMismatch
                }
            }.eraseToAnyPublisher()
    }
}
