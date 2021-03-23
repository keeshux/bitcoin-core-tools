import XCTest
import Combine
import BitcoinAPI
import JSONRPC
@testable import BitcoinWallet

final class BitcoinWalletRPCTests: XCTestCase {
    override class func setUp() {
        JSONRPC.logger.logLevel = .debug
    }
    
    private let segwitWalletName = "SegwitWallet"

    private let legacyWalletName = "LegacyWallet"

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

    private lazy var segwitWallet = WatchOnlyWallet(name: segwitWalletName, device: TestDevices.coldcard)

    private lazy var legacyWallet = WatchOnlyWallet(name: legacyWalletName, device: TestDevices.coldcard)
    
    private let timeout = 10.0
    
    private var cancellables: Set<AnyCancellable> = []

    // MARK: Bootstrap

//    func testCreate() {
//        let exp = expectation(description: "RPC")
//        segwitWallet.createPublisher(rpc)
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
//                print($0)
//            }.store(in: &cancellables)
//
//        waitForExpectations(timeout: timeout, handler: nil)
//    }
//
//    func testLoad() {
//        let exp = expectation(description: "RPC")
//        segwitWallet.loadPublisher(rpc)
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
//                print($0)
//            }.store(in: &cancellables)
//
//        waitForExpectations(timeout: timeout, handler: nil)
//    }
//
//    func testUnload() {
//        let exp = expectation(description: "RPC")
//        segwitWallet.unloadPublisher(rpc)
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
//                print($0)
//            }.store(in: &cancellables)
//
//        waitForExpectations(timeout: timeout, handler: nil)
//    }

    // MARK: RPC

    func testBalance() {
        let exp = expectation(description: "RPC")
        segwitWallet.balancePublisher(rpc)
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
            }.store(in: &cancellables)

        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testDeriveAddresses() {
        let externalAddresses = [
            "tb1qqd2euf4j8m0r9dtcz72mafr60jq6gqrgkma5sq",
            "tb1qfqqvvmtr7f0pxphuhrsqyf32t0l5xkf57fst44",
            "tb1qkhwg28twmt5tfg5e65mfpmenrkcdgzy6w2m05x"
        ]
        let internalAddresses = [
            "tb1qcj5pwr0xh9u40lj9msk9j6dfgkcpqa95evtq9m",
            "tb1q5zws3zlalnrntgsm0wpg9phtjzhptyj95cv7hj",
            "tb1qm7ng8j2rly3wdj7q8cpjunqe094474v4w6mypm"
        ]
        let range = 0...2

        let exp = expectation(description: "RPC")
        segwitWallet.derivedAddressesPublisher(rpc, forPurpose: .bip84, range: range, isExternal: true)
            .sink { result in
                switch result {
                case .finished:
                    break
                    
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            } receiveValue: {
                print($0)
                XCTAssertEqual($0, externalAddresses)
            }.store(in: &cancellables)

        segwitWallet.derivedAddressesPublisher(rpc, forPurpose: .bip84, range: range, isExternal: false)
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
                XCTAssertEqual($0, internalAddresses)
            }.store(in: &cancellables)

        waitForExpectations(timeout: timeout, handler: nil)
    }

    func testImport() {
        let exp = expectation(description: "RPC")
        segwitWallet.importPublisher(rpc, forPurpose: .bip44, timestamp: nil, rescan: false)
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
            }.store(in: &cancellables)

        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testListTransactions() {
        let expectedTxids: Set<String> = [
            "2cb1a150f2eefb2530d4fc6798ff227ba32e835547e8db821fad010aec314dd8",
            "a0f4d9a2ba49956d3b9f6254775d6fdf822fa7fc83492b8203ffb72b5bba71a3",
            "084ea149ae90f2de86436884f343f973ed39adc38bff5d0b41024b0ac1f8a9a6",
            "b5f46e5cbe87162cd57b0ef9965827e77d7a72e7b7cd7bde52d665c5891bdace"
        ]
        
        let exp = expectation(description: "RPC")
        segwitWallet.listTransactionsPublisher(rpc)
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
                
                let txids = $0.map { $0.txid }
                XCTAssertEqual(Set(txids), expectedTxids)
            }.store(in: &cancellables)

        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testGetTransaction() {
        let expectedTxid = "a0f4d9a2ba49956d3b9f6254775d6fdf822fa7fc83492b8203ffb72b5bba71a3"
        
        let exp = expectation(description: "RPC")
        segwitWallet.transactionPublisher(rpc, txid: expectedTxid)
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
                XCTAssertEqual($0.txid, expectedTxid)
            }.store(in: &cancellables)

        waitForExpectations(timeout: timeout, handler: nil)
    }

    func testListUnspent() {
        let exp = expectation(description: "RPC")
        segwitWallet.listUnspentPublisher(rpc)
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
            }.store(in: &cancellables)

        waitForExpectations(timeout: timeout, handler: nil)
    }

    func testCreatePSBT() {
        let exp = expectation(description: "RPC")
        segwitWallet.createPSBTPublisher(
            rpc,
            outputs: ["mkHS9ne12qx9pS9VojpwU5xtRd4T7X7ZUt": 0.0001],
            options: .init(includeWatching: true, replaceable: true)
        )
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
            }.store(in: &cancellables)

        waitForExpectations(timeout: timeout, handler: nil)
    }

    func testWalletInfo() {
        let exp = expectation(description: "RPC")
        segwitWallet.infoPublisher(rpc)
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
            }.store(in: &cancellables)

        waitForExpectations(timeout: timeout, handler: nil)
    }
    
//    func testStartRescan() {
//        let exp = expectation(description: "RPC")
//        segwitWallet.startRescanPublisher(rpc)
//            .sink { result in
//                switch result {
//                case .finished:
//                    break
//
//                case .failure(let error):
//                    XCTFail(error.localizedDescription)
//                }
//                exp.fulfill()
//            } receiveValue: { _ in
//            }.store(in: &cancellables)
//
//        waitForExpectations(timeout: timeout, handler: nil)
//    }
//
//    func testStopRescan() {
//        let exp = expectation(description: "RPC")
//        segwitWallet.stopRescanPublisher(rpc)
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
//                print($0)
//            }.store(in: &cancellables)
//
//        waitForExpectations(timeout: timeout, handler: nil)
//    }
    
    func testLegacyAddressInfo() {
        let expectedAddress = "2MvNZJPodpNmCc7wtMFnSWh4NacVyKtwiRv"

        let exp = expectation(description: "RPC")
        legacyWallet.addressInfoPublisher(rpc, address: expectedAddress)
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
                XCTAssertEqual($0.address, expectedAddress)
            }.store(in: &cancellables)

        waitForExpectations(timeout: timeout, handler: nil)
    }

    func testVerifyDeviceAddresses() {
        let exp = expectation(description: "RPC")
        TestDevices.coldcard.verifyAddressesPublisher(rpc, forPurpose: .bip49)
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
