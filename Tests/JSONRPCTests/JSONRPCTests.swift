import XCTest
import Combine
@testable import JSONRPC

final class JSONRPCTests: XCTestCase {
    override class func setUp() {
        JSONRPC.logger.logLevel = .debug
    }
    
    private let validCredentials: (String, String) = {
        guard let username = ProcessInfo.processInfo.environment["RPC_USERNAME"] else {
            fatalError("Set RPC_USERNAME in environment")
        }
        guard let password = ProcessInfo.processInfo.environment["RPC_PASSWORD"] else {
            fatalError("Set RPC_PASSWORD in environment")
        }
        return (username, password)
    }()

    private let timeout = 10.0
    
    private var cancellables: Set<AnyCancellable> = []

    // MARK: RPC
    
    func testSuccess() {
        let rpc = RPC.Configuration(validCredentials.0, validCredentials.1, "127.0.0.1", 18332).rpc

        let exp = expectation(description: "RPC")
        rpc.executePublisher("getblockchaininfo", path: "", arguments: [])
            .sink {
                switch $0 {
                case .finished:
                    break
                    
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
                exp.fulfill()
            } receiveValue: {
                do {
                    let json = try JSONSerialization.jsonObject(with: $0, options: []) as? [String: Any]
                    XCTAssertNotNil(json)
                    let result = json?["result"] as? [String: Any]
                    XCTAssertNotNil(result)
                    XCTAssertEqual(result?["chain"] as? String, "test")
                    XCTAssertEqual(result?["pruned"] as? Int, 0)
                } catch let e {
                    XCTFail(e.localizedDescription)
                }
            }.store(in: &cancellables)

        waitForExpectations(timeout: timeout, handler: nil)
    }

    func testNetworkFailure() {
        let rpc = RPC.Configuration(validCredentials.0, validCredentials.1, "127.0.0.1", 18330).rpc

        let exp = expectation(description: "RPC")
        rpc.executePublisher("getblockchaininfo", path: "", arguments: [])
            .sink {
                switch $0 {
                case .finished:
                    XCTFail()
                    
                case .failure(let error):
                    print(error)
                }
                exp.fulfill()
            } receiveValue: { _ in
            }.store(in: &cancellables)
        
        waitForExpectations(timeout: timeout, handler: nil)
    }

    func testBadCredentials() {
        let rpc = RPC.Configuration("bogus", "bogus", "127.0.0.1", 18332).rpc

        let exp = expectation(description: "RPC")
        rpc.executePublisher("getblockchaininfo", path: "", arguments: [])
            .sink {
                switch $0 {
                case .finished:
                    XCTFail()

                case .failure(let error):
                    print(error)
                }
                exp.fulfill()
            } receiveValue: { _ in
            }.store(in: &cancellables)
        
        waitForExpectations(timeout: timeout, handler: nil)
    }
}

extension RPC.Configuration {
    var rpc: RPC {
        RPC(version: "1.0", id: "BitcoinAPI", transport: ClearTransport(), configuration: self)
    }
}
