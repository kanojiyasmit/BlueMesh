//
//  ContentView.swift
//  BlueMesh
//
//  Created by Smit Kanojiya on 28/06/24.
//

import SwiftUI
import CoreBluetooth

struct ContentView: View {
    @ObservedObject var viewModel = BluetoothManager()
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    if viewModel.bluetoothState == .poweredOn {
                        if !viewModel.discoveredPeripherals.isEmpty {
                            List(viewModel.discoveredPeripherals, id: \.identifier) { peripheral in
                                HStack(alignment: .center) {
                                    Text(peripheral.name ?? "Unknown")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .listRowInsets(.none)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                                .onTapGesture {
                                    viewModel.connectToPeripheral(peripheral)
                                }
                            }
                            .listStyle(.plain)
                        } else {
                            VStack(spacing: 20) {
                                Text("Searching Nearby")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                                
                                Text("Searching for peripherals nearby...")
                                    .font(.body)
                                    .foregroundColor(.gray)
                                
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                    .scaleEffect(1.5)
                            }
                            .padding()
                        }
                    } else {
                        VStack(spacing: 20) {
                            Text("Bluetooth is not available")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                            
                            Text("Please ensure that Bluetooth is enabled and your device supports Bluetooth.")
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            Image(systemName: "exclamationmark.triangle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.red)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Peripherals")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: .constant(viewModel.connectedPeripheral != nil)) {
                PeripheralDetailView(bluetoothManager: viewModel)
            }
            .alert("Connecting", isPresented: .constant(viewModel.connectingPeripheral != nil)) {
                Button("Cancel") {
                    viewModel.cancelBtnAction()
                }
            } message: {
                Text("\(viewModel.connectingPeripheral?.name ?? "Unknown")")
            }
            .alert("Connection Failed", isPresented: $viewModel.connectionFailed) {
                Button("Okay") {
                    viewModel.connectionFailed.toggle()
                }
            } message: {
                Text("\(viewModel.connectingPeripheral?.name ?? "Unknown")")
            }
        }
    }
}
