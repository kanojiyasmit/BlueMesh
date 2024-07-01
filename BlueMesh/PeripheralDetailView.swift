//
//  PeripheralDetailView.swift
//  BlueMesh
//
//  Created by Smit Kanojiya on 01/07/24.
//

import SwiftUI

struct PeripheralDetailView: View {
    @ObservedObject var bluetoothManager: BluetoothManager

    var body: some View {
        ScrollView {
            if bluetoothManager.services.isEmpty {
                fetchingView
            } else {
                servicesView
            }
        }
        .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        .navigationTitle(bluetoothManager.connectedPeripheral?.name ?? "Unknown Peripheral")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            bluetoothManager.disconnectToPeripheral()
        }
    }

    private var fetchingView: some View {
        VStack(spacing: 20) {
            Text("Fetching for peripherals nearby...")
                .font(.body)
                .foregroundColor(.gray)

            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(1.5)
        }
        .padding()
    }

    private var servicesView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Services")
                .fontWeight(.bold)

            ForEach(bluetoothManager.services.indices, id: \.self) { index in
                let service = bluetoothManager.services[index]
                ServiceView(
                    service: service,
                    characteristics: bluetoothManager.characteristics.filter { $0.service?.uuid == service.uuid },
                    bluetoothManager: bluetoothManager
                )
            }
        }
        .padding()
    }
}
