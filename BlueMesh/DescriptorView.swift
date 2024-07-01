//
//  DescriptorView.swift
//  BlueMesh
//
//  Created by Smit Kanojiya on 01/07/24.
//

import SwiftUI
import CoreBluetooth

struct DescriptorView: View {
    let descriptor: CBDescriptor
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(descriptor.uuid.description)
                    .font(.subheadline)
                    .foregroundColor(.green)
                Spacer()
            }
            
            if let value = descriptor.value {
                Text("Value: \(value)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
}
