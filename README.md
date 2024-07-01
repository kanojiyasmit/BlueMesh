
# Bluetooth Low Energy (BLE) Application

## Overview

This application is designed to interact with Bluetooth Low Energy (BLE) devices. It allows users to scan for nearby BLE devices, connect to them, and read various characteristics and services provided by these devices.

## Features

- **Scanning for BLE Devices:** Discover nearby BLE devices and display them in a list.
- **Connecting to Devices:** Connect to selected BLE devices and navigate to a detailed view.
- **Displaying Services and Characteristics:** Display all available services and their characteristics for the connected device.
- **Reading and Displaying Values:** Read and display values for different characteristics and descriptors.

## Requirements

- iOS 14.0 or later
- Xcode 12.0 or later
- Swift 5.0 or later

## Installation

### Clone the Repository

```bash

git clone https://github.com/kanojiyasmit/BlueMesh.git

cd BlueMesh
```

### Open in Xcode

1. Open the \`.xcodeproj\` or \`.xcworkspace\` file in Xcode.
2. Select your target device or simulator.
3. Build and run the application.

## Usage

### Scanning for Devices

1. Open the application.
2. The app will automatically start scanning for nearby BLE devices.
3. Discovered devices will be displayed in a list.

### Connecting to a Device

1. Tap on a device from the list to connect.
2. Once connected, you will be redirected to a detailed view of the device.

### Viewing Services and Characteristics

1. The detailed view will display all available services of the connected device.
2. Characteristic values will be read and displayed automatically.

## Contributing

Contributions are welcome! Please submit a pull request or open an issue to discuss your changes.

## Acknowledgements

- [CoreBluetooth](https://developer.apple.com/documentation/corebluetooth) - Used for managing BLE operations.
- [SwiftUI](https://developer.apple.com/documentation/swiftui) - Used for building the user interface.

## Contact

For any questions or suggestions, please contact [Kanojiya23Smit@gmail.com](mailto:Kanojiya23Smit@gmail.com).
