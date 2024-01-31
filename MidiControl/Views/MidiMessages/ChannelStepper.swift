//
//  ChannelStepper.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 31.01.2024.
//

import SwiftUI

struct ChannelStepper: View {
    @Binding var value: Int16

    var body: some View {
        VStack {
            Stepper(value: $value, in: 1...16, step: 1) {
                Text("\(value)")
            }.fixedSize()
            Text("Channel")
        }.padding()
    }
}

#Preview {
    ChannelStepper(value: .constant(10))
}
