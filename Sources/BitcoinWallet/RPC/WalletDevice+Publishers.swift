//
//  WalletDevice+Publishers.swift
//  
//
//  Created by Davide De Rosa on 3/10/21.
//

import Foundation
import Combine
import BitcoinAPI
import BitcoinTools
import JSONRPC

extension WalletDevice {
    public func descriptorsPublisher(_ rpc: RPC, forPurpose purpose: HDPurpose) -> AnyPublisher<DescriptorPair, Error> {
        let pair = singleKey(forPurpose: purpose).descriptorPair
        return Publishers.Zip(
            BitcoinAPI.descriptorWithChecksumPublisher(rpc, fromDescriptor: pair.externalDescriptor),
            BitcoinAPI.descriptorWithChecksumPublisher(rpc, fromDescriptor: pair.internalDescriptor)
        ).map {
            return DescriptorPair(
                externalDescriptor: $0,
                internalDescriptor: $1
            )
        }.eraseToAnyPublisher()
    }

    public func derivedAddressesPublisher(_ rpc: RPC, forPurpose purpose: HDPurpose, range: ClosedRange<Int>, isExternal: Bool) -> AnyPublisher<[String], Error> {
        let pair = singleKey(forPurpose: purpose).descriptorPair
        let desc = isExternal ? pair.externalDescriptor : pair.internalDescriptor
        return BitcoinAPI.derivedAddressesPublisher(rpc, fromDescriptor: desc, range: range)
    }

    public func verifyAddressesPublisher(_ rpc: RPC, forPurpose purpose: HDPurpose) -> AnyPublisher<Void, Error> {
        let key = singleKey(forPurpose: purpose)
        guard let externalAddresses = key.externalAddresses, !externalAddresses.isEmpty else {
            return Empty()
                .eraseToAnyPublisher()
        }
        return BitcoinAPI.verifyAddressesPublisher(rpc, descriptor: key.descriptorPair.externalDescriptor, firstAddresses: externalAddresses)
    }
}
