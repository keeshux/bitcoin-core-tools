import XCTest
@testable import BitcoinWallet

final class BitcoinWalletDevicesTests: XCTestCase {
    func testColdcard() {
        let expectedFingerprint = "6105a380"
        let expectedBIP44XPUB = "tpubDCoCsVUC8EM5cs6RmDfsGLwLpGUvUvQUukCDPR8m1GSqvawMyWT69gS4F7seem7bURJRKN48YB9aszx6R49EzZGMrJS3DuUoPFVkZ4CHNCQ"
        let expectedBIP49XPUB = "tpubDCen93tHR18cUeGBGZcPZvQkD81XD4FAgv4xgDfAyLttHLxB9vSKjZ5DM6Qdd7gr8sNKtiChAZ7UM1Y5PU2uv9Tw9hwN1CSBtpwNXLz2gKE"
        let expectedBIP84XPUB = "tpubDCvdn9onQQsg8v8Nqtp6vXG74YxQKdhtqTGEf71SXWy315MuuYY34zKtCjPtGGG6yKtHFVq3de29GWJ9cJdQjKdMfSkujzCk6c52GKnRraK"
        let expectedBIP84Address = "tb1qqd2euf4j8m0r9dtcz72mafr60jq6gqrgkma5sq"

        let device = TestDevices.coldcard

        print(device)
        print(device.singleKey(forPurpose: .bip44).descriptorPair)
        print(device.singleKey(forPurpose: .bip49).descriptorPair)
        print(device.singleKey(forPurpose: .bip84).descriptorPair)
        print(device.bip44.xpub.rawValue)
        print(device.bip49.xpub.rawValue)
        print(device.bip84.xpub.rawValue)
        
        let bip44Address = try! device.bip44.firstAddress.asLegacyAddress()
        let bip49Address = try! device.bip49.firstAddress.asLegacyAddress()
        let bip84Address = try! device.bip84.firstAddress.asSegwitAddress()
        print(bip44Address)
        print(bip49Address)
        print(bip84Address)

        XCTAssertEqual(bip44Address.descriptorType, .pkh)
        XCTAssertEqual(bip49Address.descriptorType, .shWpkh)
        XCTAssertEqual(bip84Address.descriptorType, .wpkh)

        XCTAssertEqual(device.fingerprint.rawValue, expectedFingerprint)
        XCTAssertEqual(device.bip44.xpub.rawValue, expectedBIP44XPUB)
        XCTAssertEqual(device.bip49.xpub.rawValue, expectedBIP49XPUB)
        XCTAssertEqual(device.bip84.xpub.rawValue, expectedBIP84XPUB)
        XCTAssertEqual(device.bip84.firstAddress, expectedBIP84Address)
    }
}
