//
//  BluetoothManager.swift
//  BlueMesh
//
//  Created by Smit Kanojiya on 28/06/24.
//

import Foundation
import CoreBluetooth

class BluetoothManager: NSObject, ObservableObject {
    
    var centralManager: CBCentralManager?
    @Published var bluetoothState: CBManagerState = .unknown
    @Published var discoveredPeripherals: [CBPeripheral] = []
    @Published var connectingPeripheral: CBPeripheral?
    @Published var connectedPeripheral : CBPeripheral?
    @Published var services: [CBService] = []
    @Published var characteristics: [CBCharacteristic] = []
    @Published var descriptors: [CBDescriptor] = []
    @Published var characteristicValues: [CBCharacteristic: Data] = [:]
    @Published var connectionFailed: Bool = false
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    private func handleBluetoothStateChange(state: CBManagerState) {
        switch state {
        case .unknown:
            print("Bluetooth state is unknown")
        case .resetting:
            print("Bluetooth is resetting")
        case .unsupported:
            print("Bluetooth is unsupported")
        case .unauthorized:
            print("Bluetooth is unauthorized")
        case .poweredOff:
            print("Bluetooth is powered off")
        case .poweredOn:
            print("Bluetooth is powered on")
            startScanning()
        @unknown default:
            print("Unknown Bluetooth state")
        }
    }
    
    func startScanning() {
        print("Bluetooth Started Scanning")
        centralManager?.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func connectToPeripheral(_ peripheral :CBPeripheral) {
        connectingPeripheral = peripheral
        centralManager?.connect(peripheral, options: nil)
        print("Connecting to Peripheral name : \(String(describing: peripheral.name))")
    }
    
    func disconnectToPeripheral() {
        if let peripheral = connectedPeripheral {
            centralManager?.cancelPeripheralConnection(peripheral)
            connectedPeripheral = nil
            connectingPeripheral = nil
            discoveredPeripherals.removeAll()
            startScanning()
        }
    }
    
    func cancelBtnAction() {
        if let peripheral = connectingPeripheral {
            centralManager?.cancelPeripheralConnection(peripheral)
            connectingPeripheral = nil
            discoveredPeripherals.removeAll()
            startScanning()
        }
    }
    
    func updateCharacteristicValue(characteristic: CBCharacteristic, value: Data?) {
        if let value = value {
            characteristicValues[characteristic] = value
        } else {
            characteristicValues[characteristic] = nil
        }
    }
    
}

extension BluetoothManager: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        self.bluetoothState = central.state
        self.handleBluetoothStateChange(state: central.state)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard let name = peripheral.name, !name.isEmpty else {
            return
        }
        if !self.discoveredPeripherals.contains(where: { $0.identifier == peripheral.identifier }) {
            self.discoveredPeripherals.append(peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectingPeripheral = nil
        connectedPeripheral = peripheral
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        print("Connected to peripheral name \(String(describing: peripheral.name))")
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: (any Error)?) {
        connectingPeripheral = nil
        connectionFailed = true
        print("Failed to Connect peripheral name \(String(describing: peripheral.name))")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: (any Error)?) {
        connectingPeripheral = nil
        connectedPeripheral = nil
        services = []
        characteristics = []
        characteristicValues = [:]
        descriptors = []
        if let error = error {
            print("Disconnected from peripheral \(String(describing: peripheral.name)) with error: \(error.localizedDescription)")
        } else {
            print("Disconnected from peripheral \(String(describing: peripheral.name))")
        }
    }
}
extension BluetoothManager: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: (any Error)?) {
        guard error == nil else {
            print("Error discovering services: \(String(describing: error?.localizedDescription))")
            return
        }
        guard let services = peripheral.services else { return }
        for service in services {
            print("\(String(describing: peripheral.name)) service \(service)")
            self.services.append(service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        guard error == nil else {
            print("Error discovering characteristics: \(error!.localizedDescription)")
            return
        }
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            print("characteristics \(characteristic)")
            self.characteristics.append(characteristic)
            peripheral.discoverDescriptors(for: characteristic)
            if characteristic.properties.contains(.read) {
                peripheral.readValue(for: characteristic)
            } else if characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print("Error discovering descriptors: \(error!.localizedDescription)")
            return
        }
        guard let descriptors = characteristic.descriptors else { return }
        
        for descriptor in descriptors {
            print("\(String(describing: peripheral.name)) descriptors \(descriptor)")
            self.descriptors.append(descriptor)
            peripheral.readValue(for: descriptor)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print("Error updating value for characteristic: \(error!.localizedDescription)")
            return
        }
        guard let values = characteristic.value else { return }
        
        if let value = characteristic.value {
            updateCharacteristicValue(characteristic: characteristic, value: value)
        }
        for value in values {
            print("\(String(describing: characteristic.uuid)) values \(value)")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: (any Error)?) {
        guard error == nil else {
            print("Error updating value for descriptor: \(error!.localizedDescription)")
            return
        }
        guard let values = descriptor.value else { return }
    }
}
