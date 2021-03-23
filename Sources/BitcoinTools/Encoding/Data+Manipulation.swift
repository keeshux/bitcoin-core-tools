//
//  Data+Manipulation.swift
//
//
//  Created by Davide De Rosa on 2/20/21.
//

import Foundation

// hex -> Data conversion code from: http://stackoverflow.com/questions/32231926/nsdata-from-hex-string
// Data -> hex conversion code from: http://stackoverflow.com/questions/39075043/how-to-convert-data-to-hex-string-in-swift

public extension UnicodeScalar {
    var hexNibble: UInt8 {
        let value = self.value
        if 48 <= value && value <= 57 {
            return UInt8(value - 48)
        }
        else if 65 <= value && value <= 70 {
            return UInt8(value - 55)
        }
        else if 97 <= value && value <= 102 {
            return UInt8(value - 87)
        }
        fatalError("\(self) not a legal hex nibble")
    }
}

public extension Data {
    init(hex: String) {
        let scalars = hex.unicodeScalars
        var bytes = Array<UInt8>(repeating: 0, count: (scalars.count + 1) >> 1)
        for (index, scalar) in scalars.enumerated() {
            var nibble = scalar.hexNibble
            if index & 1 == 0 {
                nibble <<= 4
            }
            bytes[index >> 1] |= nibble
        }
        self = Data(bytes)
    }

    func toHex() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
    
    mutating func zero() {
        resetBytes(in: 0..<count)
    }

    mutating func zero(from: Int, to: Int) {
        resetBytes(in: from..<to)
    }
}

public extension Data {
    mutating func append(_ value: UInt16) {
        var localValue = value
        let buffer = withUnsafePointer(to: &localValue) {
            return UnsafeBufferPointer(start: $0, count: 1)
        }
        append(buffer)
    }
    
    mutating func append(_ value: UInt32) {
        var localValue = value
        let buffer = withUnsafePointer(to: &localValue) {
            return UnsafeBufferPointer(start: $0, count: 1)
        }
        append(buffer)
    }
    
    mutating func append(_ value: UInt64) {
        var localValue = value
        let buffer = withUnsafePointer(to: &localValue) {
            return UnsafeBufferPointer(start: $0, count: 1)
        }
        append(buffer)
    }
    
    mutating func append(nullTerminatedString: String) {
        append(nullTerminatedString.data(using: .ascii)!)
        append(UInt8(0))
    }

    func nullTerminatedString(from: Int) -> String? {
        var nullOffset: Int?
        for i in from..<count {
            if (self[i] == 0) {
                nullOffset = i
                break
            }
        }
        guard let to = nullOffset else {
            return nil
        }
        return String(data: subdata(in: from..<to), encoding: .ascii)
    }

    func UInt16Value(from: Int) -> UInt16 {
        var value: UInt16 = 0
        for i in 0..<2 {
            let byte = self[from + i]
            value |= (UInt16(byte) << UInt16(8 * i))
        }
        return value
    }
    
    func UInt32Value(from: Int) -> UInt32 {
        return subdata(in: from..<(from + 4)).withUnsafeBytes {
            $0.load(as: UInt32.self)
        }
    }

    func networkUInt16Value(from: Int) -> UInt16 {
        return UInt16(bigEndian: subdata(in: from..<(from + 2)).withUnsafeBytes {
            $0.load(as: UInt16.self)
        })
    }

    func networkUInt32Value(from: Int) -> UInt32 {
        return UInt32(bigEndian: subdata(in: from..<(from + 4)).withUnsafeBytes {
            $0.load(as: UInt32.self)
        })
    }
}

public extension Data {
    func subdata(offset: Int, count: Int) -> Data {
        return subdata(in: offset..<(offset + count))
    }
}

public extension Array where Element == Data {
    var flatCount: Int {
        return reduce(0) { $0 + $1.count }
    }
}

public extension UnsafeRawBufferPointer {
    var bytePointer: UnsafePointer<Element> {
        return bindMemory(to: Element.self).baseAddress!
    }
}

public extension UnsafeMutableRawBufferPointer {
    var bytePointer: UnsafeMutablePointer<Element> {
        return bindMemory(to: Element.self).baseAddress!
    }
}
