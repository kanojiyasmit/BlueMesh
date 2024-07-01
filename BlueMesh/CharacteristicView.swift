//
//  CharacteristicView.swift
//  BlueMesh
//
//  Created by Smit Kanojiya on 01/07/24.
//

import SwiftUI
import CoreBluetooth

struct CharacteristicView: View {
    let characteristic: CBCharacteristic
    let value: Data?
    let descriptors: [CBDescriptor]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            
            HStack {
                Text(characteristic.uuid.description)
                    .font(.subheadline)
                    .foregroundColor(.blue)
                Spacer()
            }
            Text("Properties: \(characteristic.properties.description)")
                .font(.caption)
                .foregroundColor(.gray)
            Text("Notifying: \(characteristic.isNotifying ? "Yes" : "No")")
                .font(.caption)
                .foregroundColor(.gray)
            if let value = value {
                Text("Value: \(formattedValue(value, for: characteristic.uuid))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            if !descriptors.isEmpty {
                Text("Descriptors")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .fontWeight(.bold)
                
                ForEach(Array(descriptors.enumerated()), id: \.element) { index, descriptor in
                    DescriptorView(descriptor: descriptor)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func formattedValue(_ value: Data, for uuid: CBUUID) -> String {
        switch uuid {
        case CBUUID(string: "2A19"): // Battery Level
            return formatBatteryLevel(value)
        case CBUUID(string: "2A37"): // Heart Rate Measurement
            return formatHeartRateMeasurement(value)
        case CBUUID(string: "2A29"): // Manufacturer Name String
            return formatManufacturerNameString(value)
        case CBUUID(string: "2A24"): // Model Number String
            return formatModelNumberString(value)
        case CBUUID(string: "2A00"): // Device Name
            return formatDeviceName(value)
        case CBUUID(string: "2A01"): // Appearance
            return formatAppearance(value)
        case CBUUID(string: "2A6E"): // Temperature
            return formatTemperature(value)
        case CBUUID(string: "2A49"): // Blood Pressure Feature
            return formatBloodPressureFeature(value)
        case CBUUID(string: "2A1C"): // Temperature Measurement
            return formatTemperatureMeasurement(value)
        case CBUUID(string: "2A19"): // Battery Level
            return formatBatteryLevel(value)
        case CBUUID(string: "2A46"): // New Alert
            return formatNewAlert(value)
        case CBUUID(string: "2A44"): // Alert Notification Control Point
            return formatAlertNotificationControlPoint(value)
        case CBUUID(string: "2A4D"): // Report
            return formatReport(value)
        case CBUUID(string: "2A4B"): // Protocol Mode
            return formatProtocolMode(value)
        case CBUUID(string: "2A4E"): // Report Reference
            return formatReportReference(value)
        case CBUUID(string: "2A3F"): // Alert Status
            return formatAlertStatus(value)
        case CBUUID(string: "2A4F"): // HID Information
            return formatHIDInformation(value)
        default:
            return value.hexEncodedString()
        }
    }
    
    private func formatBatteryLevel(_ value: Data) -> String {
        guard let batteryLevel = value.first else { return "Unknown" }
        return "\(batteryLevel)%"
    }
    
    private func formatHeartRateMeasurement(_ value: Data) -> String {
        let heartRate = value.withUnsafeBytes { $0.load(as: UInt8.self) }
        return "\(heartRate) BPM"
    }
    
    private func formatManufacturerNameString(_ value: Data) -> String {
        return String(data: value, encoding: .utf8) ?? "Unknown"
    }
    
    private func formatModelNumberString(_ value: Data) -> String {
        return String(data: value, encoding: .utf8) ?? "Unknown"
    }
    
    private func formatDeviceName(_ value: Data) -> String {
        return String(data: value, encoding: .utf8) ?? "Unknown"
    }
    
    private func formatAppearance(_ value: Data) -> String {
        let appearance = value.withUnsafeBytes { $0.load(as: UInt16.self) }
        return "Appearance: \(appearance)"
    }
    
    private func formatTemperature(_ value: Data) -> String {
        let temperature = value.withUnsafeBytes { $0.load(as: Float.self) }
        return String(format: "%.2f°C", temperature)
    }
    
    private func formatBloodPressureFeature(_ value: Data) -> String {
        let feature = value.withUnsafeBytes { $0.load(as: UInt8.self) }
        return "Blood Pressure Feature: \(feature)"
    }
    
    private func formatTemperatureMeasurement(_ value: Data) -> String {
        let temperatureMeasurement = value.withUnsafeBytes { $0.load(as: Float.self) }
        return String(format: "%.2f°C", temperatureMeasurement)
    }
    
    private func formatNewAlert(_ value: Data) -> String {
        return String(data: value, encoding: .utf8) ?? "Unknown Alert"
    }
    
    private func formatAlertNotificationControlPoint(_ value: Data) -> String {
        let alertPoint = value.withUnsafeBytes { $0.load(as: UInt8.self) }
        return "Alert Notification Control Point: \(alertPoint)"
    }
    
    private func formatReport(_ value: Data) -> String {
        return value.hexEncodedString()
    }
    
    private func formatProtocolMode(_ value: Data) -> String {
        let mode = value.withUnsafeBytes { $0.load(as: UInt8.self) }
        return "Protocol Mode: \(mode)"
    }
    
    private func formatReportReference(_ value: Data) -> String {
        return value.hexEncodedString()
    }
    
    private func formatAlertStatus(_ value: Data) -> String {
        let status = value.withUnsafeBytes { $0.load(as: UInt8.self) }
        return "Alert Status: \(status)"
    }
    
    private func formatHIDInformation(_ value: Data) -> String {
        return value.hexEncodedString()
    }
}

