//
//  TextFieldUint8.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 13.01.2024.
//

import SwiftUI

struct TextFieldUInt8 : View {
    var value: Binding<UInt8>
    var name: String
    var emptyText: String

    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimum = 0
        formatter.maximum = 255
        return formatter
    }()

    var body: some View {
        HStack {
            Text(name)
            TextField(emptyText, value: value, formatter: formatter)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }.padding()
    }
}

#Preview {
    TextFieldUInt8(value: .constant(55), name: "Preview", emptyText: "Enter")
}
