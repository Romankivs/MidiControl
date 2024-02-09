//
//  TextFieldUint8.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 13.01.2024.
//

import SwiftUI

struct TextFieldUInt<T> : View {
    var value: Binding<T>
    var name: String
    var emptyText: String

    var minimum: NSNumber = 0
    var maximum: NSNumber = 127

    var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimum = minimum
        formatter.maximum = maximum
        return formatter
    }

    var body: some View {
        VStack {
            TextField(emptyText, value: value, formatter: formatter)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Text(name)
        }.padding()
    }
}

typealias TextFieldUInt8 = TextFieldUInt<Int16>
typealias TextFieldUInt16 = TextFieldUInt<Int32>
typealias TextFieldUInt32 = TextFieldUInt<Int64>
typealias TextFieldDouble = TextFieldUInt<Double>

#Preview {
    TextFieldUInt8(value: .constant(55), name: "Preview", emptyText: "Enter")
}
