//
//  TestDevices.swift
//  
//
//  Created by Davide De Rosa on 3/23/21.
//

import Foundation
@testable import BitcoinWallet

struct TestDevices {
    static let coldcard = parseDevice(ColdcardDevice.self, filename: "coldcard")
}

private func parseDevice<D: WalletDevice & Decodable>(_ deviceType: D.Type, filename: String) -> D {
    guard let url = Bundle.module.url(forResource: filename, withExtension: "json") else {
        fatalError("Could not find JSON for test device: '\(filename).json'")
    }
    do {
        let export = try Data(contentsOf: url)
//        let exportString = try String(contentsOf: url)
//        print(exportString)
        return try JSONDecoder().decode(deviceType, from: export)
    } catch let e {
        fatalError(e.localizedDescription)
    }
}
