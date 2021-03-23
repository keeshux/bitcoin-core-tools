//
//  WatchOnlyWallet+Publishers.swift
//  
//
//  Created by Davide De Rosa on 3/6/21.
//

import Foundation
import Combine
import JSONRPC
import BitcoinAPI
import BitcoinTools

extension WatchOnlyWallet {
    public func createPublisher(_ rpc: RPC) -> AnyPublisher<Void, Error> {
        CreateWalletCommand(walletName: name, disablePrivateKeys: true, blank: true).executePublisher(rpc)
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
    public func loadPublisher(_ rpc: RPC) -> AnyPublisher<Void, Error> {
        LoadWalletCommand(walletName: name).executePublisher(rpc)
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
    public func unloadPublisher(_ rpc: RPC) -> AnyPublisher<Void, Error> {
        UnloadWalletCommand(walletName: name).executePublisher(rpc)
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
    public func descriptorsPublisher(_ rpc: RPC, forPurpose purpose: HDPurpose) -> AnyPublisher<DescriptorPair, Error> {
        return device.descriptorsPublisher(rpc, forPurpose: purpose)
    }
    
    public func derivedAddressesPublisher(_ rpc: RPC, forPurpose purpose: HDPurpose, range: ClosedRange<Int>, isExternal: Bool) -> AnyPublisher<[String], Error> {
        return device.derivedAddressesPublisher(rpc, forPurpose: purpose, range: range, isExternal: isExternal)
    }
    
    public func verifyAddressesPublisher(_ rpc: RPC, forPurpose purpose: HDPurpose) -> AnyPublisher<Void, Error> {
        return device.verifyAddressesPublisher(rpc, forPurpose: purpose)
    }

    public func importPublisher(_ rpc: RPC, forPurpose purpose: HDPurpose, timestamp: Int?, rescan: Bool) -> AnyPublisher<Void, Error> {
        descriptorsPublisher(rpc, forPurpose: purpose)
            .flatMap {
                ImportMultiCommand(
                    walletName: name,
                    descriptors: [
                        ($0.externalDescriptor, false),
                        ($0.internalDescriptor, true)
                    ],
                    timestamp: timestamp,
                    rescan: rescan
                ).executePublisher(rpc)
            }.map {
                guard ($0.result.allSatisfy { $0.success }) else {
                    return
                }
            }.eraseToAnyPublisher()
    }

    public func balancePublisher(_ rpc: RPC) -> AnyPublisher<Double, Error> {
        GetBalanceCommand(walletName: name).executePublisher(rpc)
            .map { $0.result! }
            .eraseToAnyPublisher()
    }
    
    public func infoPublisher(_ rpc: RPC) -> AnyPublisher<WalletInfo, Error> {
        GetWalletInfoCommand(walletName: name).executePublisher(rpc)
            .map { $0.result! }
            .eraseToAnyPublisher()
    }
    
    public func addressInfoPublisher(_ rpc: RPC, address: String) -> AnyPublisher<AddressInfo, Error> {
        GetAddressInfoCommand(walletName: name, address: address).executePublisher(rpc)
            .map { $0.result! }
            .eraseToAnyPublisher()
    }
    
    public func listTransactionsPublisher(_ rpc: RPC) -> AnyPublisher<[WalletTransaction], Error> {
        ListTransactionsCommand(walletName: name).executePublisher(rpc)
            .map { $0.result! }
            .eraseToAnyPublisher()
    }

    public func rawTransactionPublisher(_ rpc: RPC, txid: String) -> AnyPublisher<String, Error> {
        GetTransactionCommand(walletName: name, txid: txid).executePublisher(rpc)
            .map { $0.result!.hex! }
            .eraseToAnyPublisher()
    }

    public func transactionPublisher(_ rpc: RPC, txid: String) -> AnyPublisher<Transaction, Error> {
        rawTransactionPublisher(rpc, txid: txid)
            .flatMap {
                DecodeRawTransactionCommand(hex: $0).executePublisher(rpc)
            }.map { $0.result! }
            .eraseToAnyPublisher()
    }
    
    public func listUnspentPublisher(_ rpc: RPC) -> AnyPublisher<[UTXO], Error> {
        ListUnspentCommand(walletName: name).executePublisher(rpc)
            .map { $0.result! }
            .eraseToAnyPublisher()
    }
    
    public func createPSBTPublisher(_ rpc: RPC, outputs: [String: Double], options: WalletCreateFundedPSBTCommand.Options?) -> AnyPublisher<String, Error> {
        WalletCreateFundedPSBTCommand(walletName: name, outputs: outputs, options: options).executePublisher(rpc)
            .map { $0.result!.psbt.base64EncodedString() }
            .eraseToAnyPublisher()
    }

    public func startRescanPublisher(_ rpc: RPC) -> AnyPublisher<Void, Error> {
        RescanBlockchainCommand(walletName: name).executePublisher(rpc)
            .map { _ in }
            .eraseToAnyPublisher()
    }

    public func stopRescanPublisher(_ rpc: RPC) -> AnyPublisher<Bool, Error> {
        AbortRescanCommand(walletName: name).executePublisher(rpc)
            .map { $0.result! }
            .eraseToAnyPublisher()
    }
}
