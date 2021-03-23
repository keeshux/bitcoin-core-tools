import XCTest
import Combine
import JSONRPC
@testable import BitcoinAPI

final class BitcoinAPITests: XCTestCase {
    override class func setUp() {
        JSONRPC.logger.logLevel = .debug
    }
    
    private let rpc: RPC = {
        guard let username = ProcessInfo.processInfo.environment["RPC_USERNAME"] else {
            fatalError("Set RPC_USERNAME in environment")
        }
        guard let password = ProcessInfo.processInfo.environment["RPC_PASSWORD"] else {
            fatalError("Set RPC_PASSWORD in environment")
        }
        let cfg = RPC.Configuration(username, password, "127.0.0.1", 18332)
        return RPC(version: "1.0", id: "BitcoinAPI", transport: ClearTransport(), configuration: cfg)
    }()
    
    private let timeout = 10.0
    
    private var cancellables: Set<AnyCancellable> = []

    // MARK: RPC

    func testGetBlockchainInfo() {
        let exp = expectation(description: "RPC")
        GetBlockchainInfoCommand().executePublisher(rpc)
            .sink { result in
                switch result {
                case .finished:
                    break
                    
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
                exp.fulfill()
            } receiveValue: {
                print($0.result!)
                XCTAssertEqual($0.result!.chain, .test)
            }.store(in: &cancellables)

        waitForExpectations(timeout: timeout, handler: nil)
    }

    func testGetNetworkInfo() {
        let exp = expectation(description: "RPC")
        GetNetworkInfoCommand().executePublisher(rpc)
            .sink { result in
                switch result {
                case .finished:
                    break
                    
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
                exp.fulfill()
            } receiveValue: {
                print($0.result!)
                XCTAssertEqual($0.result!.subVersion, "/Satoshi:0.20.1/")
            }.store(in: &cancellables)

        waitForExpectations(timeout: timeout, handler: nil)
    }

    func testGetBlock() {
        let blockId = "0000000000000019572f43af3882d5d5d5ab331804a7594942a767b4f3e15fa7"

        let exp = expectation(description: "RPC")
        GetBlockCommand(blockId: blockId).executePublisher(rpc)
            .sink { result in
                switch result {
                case .finished:
                    break
                    
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
                exp.fulfill()
            } receiveValue: {
                print($0.result!)
                XCTAssertEqual($0.result!.hash, blockId)
            }.store(in: &cancellables)

        waitForExpectations(timeout: timeout, handler: nil)
    }

    func testGetBlockHash() {
        let genesisId = "000000000933ea01ad0ee984209779baaec3ced90fa3f408719526f8d77f4943"
        
        let exp = expectation(description: "RPC")
        GetBlockHashCommand(blockHeight: 0).executePublisher(rpc)
            .sink { result in
                switch result {
                case .finished:
                    break
                    
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
                exp.fulfill()
            } receiveValue: {
                print($0.result!)
                XCTAssertEqual($0.result!, genesisId)
            }.store(in: &cancellables)

        waitForExpectations(timeout: timeout, handler: nil)
    }

//    func testGetRawTransaction() {
//        let txid = "c98723a89656e2d9eb6d646794dc7aa7a37499edbda438e3b7d637774dfe7ed2"
//
//        let exp = expectation(description: "RPC")
//        GetRawTransactionCommand(txid: txid).executePublisher(rpc)
//            .sink { result in
//                switch result {
//                case .finished:
//                    break
//
//                case .failure(let error):
//                    XCTFail(error.localizedDescription)
//                }
//                exp.fulfill()
//            } receiveValue: {
//                print($0.result!)
//                XCTAssertEqual($0.result!.txid, txid)
//            }.store(in: &cancellables)
//
//        waitForExpectations(timeout: timeout, handler: nil)
//    }
    
    func testDecodeRawTransaction() {
        let expectedTxid = "2cb1a150f2eefb2530d4fc6798ff227ba32e835547e8db821fad010aec314dd8"
        let expectedHex = "020000000001024bef36ac1ab07a2550de182fe1be58e6648d1dd476328e4e23deb9ae829a4b3300000000000100000082ee9fc301ad747012381e276e699fdb5b4c748d2052e2761a5529cd6161e60200000000000100000001dbf519000000000016001403559e26b23ede32b5781795bea47a7c81a4006802483045022100c39382aa36ea4bc3d5751443308c7d19ac49156fdf95e8cd61bbc3753585f841022073d2f8665e2a7d1d6c5c616feee613f285c28c2b122394e7720dbda9332aa5890121035bedcf55d6b42183bb9bf7eb389e906b103cb75ec771d9386f34973b470e56fe02473044022027167aa415d62dd76b4f6722d7d1e0b45a604446ee7ef5034cade1850b1162ef02207f4363d9155a082439e48d2168e12db47e7bac87bccbde98e6d8c114659035200121023ec6db3d2a99eed8beee821b04f4b0f25581601d7886da36c3ca11f24f6abf0a00000000"
        
        let exp = expectation(description: "RPC")
        DecodeRawTransactionCommand(hex: expectedHex).executePublisher(rpc)
            .sink { result in
                switch result {
                case .finished:
                    break
                    
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
                exp.fulfill()
            } receiveValue: {
                print($0)
                XCTAssertEqual($0.result?.txid, expectedTxid)
            }.store(in: &cancellables)

        waitForExpectations(timeout: timeout, handler: nil)
    }

    func testDecodePSBT() {
        let txid = "e14a2aa6af162a4d0fff063d78ef2e46bccaeff0df3935da3109119604c4b5f8"
        let psbtString = "cHNidP8BAHQCAAAAAaNxulsrt/8DgitJg/ynL4Lfb113VGKfO22VSbqi2fSgAAAAAAD9////AhAnAAAAAAAAGXapFDRKD0jKFQ7CuQOBdmC5tosTpnAmiKy+gxcAAAAAABYAFIOZZHvfCKrh/qbQ9dJFGyqfz8jHAAAAAAABAHECAAAAAdhNMewKAa0fgtvoR1WDLqN7Iv+YZ/zUMCX77vJQobEsAAAAAAD9////Al6rFwAAAAAAFgAUkD00VQektK0nUld4i67fkO8G6z7wSQIAAAAAABYAFKjVklNZ7WTLkETuELvpFolP+6dXAAAAAAEBH16rFwAAAAAAFgAUkD00VQektK0nUld4i67fkO8G6z4iBgNJ3g+OQ4cPrOTgH22yeU6zoTPoXaPvYOzYMcEhEORqMRhhBaOAVAAAgAEAAIAAAACAAQAAAAgAAAAAACICAjHg4UIbHKhp0qPTqGvCI5rdTw0E9FD2YBPUY3StxFCXGGEFo4BUAACAAQAAgAAAAIABAAAAGQAAAAA="

        let exp = expectation(description: "RPC")
        DecodePSBTCommand(psbtString: psbtString)!.executePublisher(rpc)
            .sink { result in
                switch result {
                case .finished:
                    break
                    
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
                exp.fulfill()
            } receiveValue: {
                print($0.result!)
                XCTAssertEqual($0.result!.tx.txid, txid)
            }.store(in: &cancellables)

        waitForExpectations(timeout: timeout, handler: nil)
    }

    func testListWallets() {
        let exp = expectation(description: "RPC")
        ListWalletsCommand().executePublisher(rpc)
            .sink { result in
                switch result {
                case .finished:
                    break
                    
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
                exp.fulfill()
            } receiveValue: {
                print($0.result!)
                XCTAssertFalse($0.result!.isEmpty)
            }.store(in: &cancellables)

        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    // MARK: Custom
    
    func testCustomGetDescriptorInfo() {
        let checksumDesc = "wpkh([6105a380/84h/1h/0h]tpubDCvdn9onQQsg8v8Nqtp6vXG74YxQKdhtqTGEf71SXWy315MuuYY34zKtCjPtGGG6yKtHFVq3de29GWJ9cJdQjKdMfSkujzCk6c52GKnRraK/0/*)#3grygkvk"
        let desc = "wpkh([6105a380/84h/1h/0h]tpubDCvdn9onQQsg8v8Nqtp6vXG74YxQKdhtqTGEf71SXWy315MuuYY34zKtCjPtGGG6yKtHFVq3de29GWJ9cJdQjKdMfSkujzCk6c52GKnRraK/0/*)"

        let exp = expectation(description: "RPC")
        BitcoinAPI.descriptorWithChecksumPublisher(rpc, fromDescriptor: desc)
            .sink { result in
                switch result {
                case .finished:
                    break
                    
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
                exp.fulfill()
            } receiveValue: {
                print($0)
                XCTAssertEqual($0, checksumDesc)
            }.store(in: &cancellables)

        waitForExpectations(timeout: timeout, handler: nil)
    }

    func testCustomDeriveAddresses() {
        let externalAddresses = [
            "tb1qqd2euf4j8m0r9dtcz72mafr60jq6gqrgkma5sq",
            "tb1qfqqvvmtr7f0pxphuhrsqyf32t0l5xkf57fst44",
            "tb1qkhwg28twmt5tfg5e65mfpmenrkcdgzy6w2m05x"
        ]
        let desc = "wpkh([6105a380/84h/1h/0h]tpubDCvdn9onQQsg8v8Nqtp6vXG74YxQKdhtqTGEf71SXWy315MuuYY34zKtCjPtGGG6yKtHFVq3de29GWJ9cJdQjKdMfSkujzCk6c52GKnRraK/0/*)"

        let exp = expectation(description: "RPC")
        BitcoinAPI.derivedAddressesPublisher(rpc, fromDescriptor: desc, range: 0...2)
            .sink { result in
                switch result {
                case .finished:
                    break
                    
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
                exp.fulfill()
            } receiveValue: {
                print($0)
                XCTAssertEqual($0, externalAddresses)
            }.store(in: &cancellables)

        waitForExpectations(timeout: timeout, handler: nil)
    }

    func testCustomVerifyAddresses() {
        let externalAddresses = [
            "tb1qqd2euf4j8m0r9dtcz72mafr60jq6gqrgkma5sq",
            "tb1qfqqvvmtr7f0pxphuhrsqyf32t0l5xkf57fst44",
            "tb1qkhwg28twmt5tfg5e65mfpmenrkcdgzy6w2m05x"
        ]
        let desc = "wpkh([6105a380/84h/1h/0h]tpubDCvdn9onQQsg8v8Nqtp6vXG74YxQKdhtqTGEf71SXWy315MuuYY34zKtCjPtGGG6yKtHFVq3de29GWJ9cJdQjKdMfSkujzCk6c52GKnRraK/0/*)"

        let exp = expectation(description: "RPC")
        BitcoinAPI.verifyAddressesPublisher(rpc, descriptor: desc, firstAddresses: externalAddresses)
            .sink { result in
                switch result {
                case .finished:
                    break
                    
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
                exp.fulfill()
            } receiveValue: { _ in
            }.store(in: &cancellables)

        waitForExpectations(timeout: timeout, handler: nil)
    }
}
