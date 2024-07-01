//
//  ServiceView.swift
//  BlueMesh
//
//  Created by Smit Kanojiya on 01/07/24.
//

import SwiftUI
import CoreBluetooth

struct ServiceView: View {
    let service: CBService
    let characteristics: [CBCharacteristic]
    @ObservedObject var bluetoothManager: BluetoothManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                Text(service.uuid.name ?? service.uuid.description)
                    .font(.headline)
                Spacer()
            }
            Text("isPrimary: \(service.isPrimary ? "Yes" : "No")")
                .font(.caption)
                .foregroundColor(.gray)
            
            if !characteristics.isEmpty {
                Text("Characteristics")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .fontWeight(.bold)
                ForEach(Array(characteristics.enumerated()), id: \.element) { index, characteristic in
                    CharacteristicView(
                        characteristic: characteristic,
                        value: bluetoothManager.characteristicValues[characteristic],
                        descriptors: bluetoothManager.descriptors.filter { $0.characteristic?.uuid == characteristic.uuid }
                    )
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
