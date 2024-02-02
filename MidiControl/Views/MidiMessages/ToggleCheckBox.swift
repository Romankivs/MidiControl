//
//  ToggleView.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 02.02.2024.
//

import SwiftUI

struct ToggleCheckBox: View {
    let text: String
    @Binding var value: Bool

    var body: some View {
        VStack {
            Toggle(isOn: $value) {
            }.labelsHidden()
            Text(text)
        }
    }
}

#Preview {
    ToggleCheckBox(text: "Preview", value: .constant(true))
}
