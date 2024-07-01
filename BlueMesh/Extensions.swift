//
//  Extensions.swift
//  BlueMesh
//
//  Created by Smit Kanojiya on 30/06/24.
//

import Foundation
import CoreBluetooth

extension CBCharacteristicProperties: CustomStringConvertible {
    public var description: String {
        var properties = [String]()
        if contains(.broadcast) { properties.append("Broadcast") }
        if contains(.read) { properties.append("Read") }
        if contains(.writeWithoutResponse) { properties.append("Write Without Response") }
        if contains(.write) { properties.append("Write") }
        if contains(.notify) { properties.append("Notify") }
        if contains(.indicate) { properties.append("Indicate") }
        if contains(.authenticatedSignedWrites) { properties.append("Authenticated Signed Writes") }
        if contains(.extendedProperties) { properties.append("Extended Properties") }
        if contains(.notifyEncryptionRequired) { properties.append("Notify Encryption Required") }
        if contains(.indicateEncryptionRequired) { properties.append("Indicate Encryption Required") }
        return properties.joined(separator: ", ")
    }
}

extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
