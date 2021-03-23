import XCTest
@testable import BitcoinTools

final class BitcoinToolsTests: XCTestCase {
    func testHex() {
        let hash = try! "0000000000000019572f43af3882d5d5d5ab331804a7594942a767b4f3e15fa7".asHash256()
        print(hash.string)
        XCTAssertEqual(hash.string.count, 64)
    }
    
    func testBase58Encoding() {
        let addressData = "003564a74f9ddb4372301c49154605573d7d1a88fe".hexData!
        XCTAssertEqual(addressData.count, 1 + 20)
        XCTAssertEqual(addressData.base58CheckString, "15sKPhXzhXbTRDHby15b45AeodmCWXzj8G")
    }

    func testBase58Decoding() {
        let address = "15sKPhXzhXbTRDHby15b45AeodmCWXzj8G"
        let addressData = address.base58CheckData!
        XCTAssertEqual(addressData.count, 1 + 20)
        XCTAssertEqual(addressData.hexString, "003564a74f9ddb4372301c49154605573d7d1a88fe")
    }
    
    func testBIP44Address() {
        let address = "mhizHQkHC7PoUSsRb2PChyad3xBPiQaDMX"
        let addressData = address.base58CheckData!
        let version = addressData[0]
        XCTAssertEqual(version, LegacyAddress.Version.testPKH.rawValue)
        
        let addressObject = try! address.asLegacyAddress()
        XCTAssertEqual(addressObject.network, .testnet)
        XCTAssertEqual(addressObject.descriptorType, .pkh)
        XCTAssertEqual(addressObject.hash160, addressData[1..<addressData.count])

        let addressJSON = try! JSONEncoder().encode(addressObject)
        let decodedAddressObject = try! JSONDecoder().decode(LegacyAddress.self, from: addressJSON)
        XCTAssertEqual(addressObject.network, decodedAddressObject.network)
        XCTAssertEqual(addressObject.descriptorType, decodedAddressObject.descriptorType)
        XCTAssertEqual(addressObject.hash160, decodedAddressObject.hash160)
        XCTAssertEqual(addressObject, decodedAddressObject)
    }

    func testBIP49Address() {
        let address = "2MvNZJPodpNmCc7wtMFnSWh4NacVyKtwiRv"
        let addressData = address.base58CheckData!
        let version = addressData[0]
        XCTAssertEqual(version, LegacyAddress.Version.testSH.rawValue)
        
        let addressObject = try! address.asLegacyAddress()
        XCTAssertEqual(addressObject.network, .testnet)
        XCTAssertEqual(addressObject.descriptorType, .shWpkh)
        XCTAssertEqual(addressObject.hash160, addressData[1..<addressData.count])

        let addressJSON = try! JSONEncoder().encode(addressObject)
        let decodedAddressObject = try! JSONDecoder().decode(LegacyAddress.self, from: addressJSON)
        XCTAssertEqual(addressObject.network, decodedAddressObject.network)
        XCTAssertEqual(addressObject.descriptorType, decodedAddressObject.descriptorType)
        XCTAssertEqual(addressObject.hash160, decodedAddressObject.hash160)
        XCTAssertEqual(addressObject, decodedAddressObject)
    }
    
    func testBech32_WPKH() {
        let address = "tb1q0hpxs3rqdpys2rnecxv66fxpjs97tn7ct9622w"
        let addressObject = try! address.asSegwitAddress()
        XCTAssertEqual(addressObject.network, .testnet)
        XCTAssertEqual(addressObject.version, 0x00)
        XCTAssertEqual(addressObject.descriptorType, .wpkh)

        let addressJSON = try! JSONEncoder().encode(addressObject)
        let decodedAddressObject = try! JSONDecoder().decode(SegwitAddress.self, from: addressJSON)
        XCTAssertEqual(addressObject.network, decodedAddressObject.network)
        XCTAssertEqual(addressObject.version, decodedAddressObject.version)
        XCTAssertEqual(addressObject.descriptorType, decodedAddressObject.descriptorType)
        XCTAssertEqual(addressObject.program, decodedAddressObject.program)
        XCTAssertEqual(addressObject, decodedAddressObject)
    }

    func testBech32_WSH() {
        let address = "tb1qrp33g0q5c5txsp9arysrx4k6zdkfs4nce4xj0gdcccefvpysxf3q0sl5k7"
        let addressObject = try! address.asSegwitAddress()
        XCTAssertEqual(addressObject.network, .testnet)
        XCTAssertEqual(addressObject.version, 0x00)
        XCTAssertEqual(addressObject.descriptorType, .wsh)

        let addressJSON = try! JSONEncoder().encode(addressObject)
        let decodedAddressObject = try! JSONDecoder().decode(SegwitAddress.self, from: addressJSON)
        XCTAssertEqual(addressObject.network, decodedAddressObject.network)
        XCTAssertEqual(addressObject.version, decodedAddressObject.version)
        XCTAssertEqual(addressObject.descriptorType, decodedAddressObject.descriptorType)
        XCTAssertEqual(addressObject.program, decodedAddressObject.program)
        XCTAssertEqual(addressObject, decodedAddressObject)
    }

    func testXPUB() {
        let string = "tpubD6NzVbkrYhZ4XorDDAM2JAvBKGGwHPp9jGt74pyQgAamdFyHCj2ESPTWmmNeN4NVAZ7f3uanKe31bH9iQBSaVjHBBo8TUmJCf8rppNVuArW"
        let xpub = try! string.asXPUBKey()
        print(string.base58CheckData!.hexString)
        print(xpub.publicKey.hexString)
        let xpubData = try! JSONEncoder().encode(xpub)
        let decodedXpub = try! JSONDecoder().decode(XPUBKey.self, from: xpubData)
        XCTAssertEqual(xpub.network, decodedXpub.network)
        XCTAssertEqual(xpub.publicKey, decodedXpub.publicKey)
        XCTAssertEqual(xpub.rawValue, decodedXpub.rawValue)
        XCTAssertEqual(xpub.rawValue, string)
        XCTAssertEqual(xpub, decodedXpub)
    }

    func testDerivationPath() {
        let path = "bfe3fba3/1/2/3'/4'"
        let hdp = try! path.asHDDerivationPath()
        XCTAssertNoThrow(try hdp.masterFingerprint?.hex.asHDFingerprint())
        print(hdp.masterFingerprint!)
        print(hdp.nodes)
        print(hdp.rawValue)

        let hdpData = try! JSONEncoder().encode(hdp)
        let decodedHdp = try! JSONDecoder().decode(HDDerivationPath.self, from: hdpData)
        XCTAssertEqual(hdp.masterFingerprint, decodedHdp.masterFingerprint)
        XCTAssertEqual(hdp.nodes, decodedHdp.nodes)
        XCTAssertEqual(hdp.rawValue, decodedHdp.rawValue)
        XCTAssertEqual(hdp, decodedHdp)
    }
}
