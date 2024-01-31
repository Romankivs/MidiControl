//
//  KeyStrokeView.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 18.01.2024.
//

import SwiftUI

struct ToggleButton: View {
    let iconName: String

    @Binding var value: Bool

    var body: some View {
        Button(action: { value.toggle() }) {
            Image(systemName: iconName)
                .foregroundColor(value ? Color.blue : Color.black)
        }
    }
}

struct KeyStrokeView: View {
    @ObservedObject var stroke: KeyStroke

    @Environment(\.managedObjectContext) var moc

    var body: some View {
        HStack {
            Picker("Action", selection: $stroke.unwrappedAction) {
                Text("Press").tag(KeyStrokeAction.press)
                Text("Hold").tag(KeyStrokeAction.hold)
                Text("Release").tag(KeyStrokeAction.release)
            }
            .padding(.horizontal)
            .labelsHidden()
            Picker("Key", selection: $stroke.unwrappedKeyCode) {
                ForEach(KeyCode.allCases) { code in
                    Text(code.description)
                }
            }
            .padding(.horizontal)
            ToggleButton(iconName: "command", value: $stroke.command)
            ToggleButton(iconName: "option", value: $stroke.option)
            ToggleButton(iconName: "control", value: $stroke.control)
            ToggleButton(iconName: "shift", value: $stroke.shift)
        }
        .padding(5.0)
        .onChange(of: [stroke.action, stroke.keyCode]) { _ in
            try? moc.save()
        }
        .onChange(of: [stroke.command, stroke.option, stroke.control, stroke.shift]) { _ in
            try? moc.save()
        }
    }
}

func getPreviewKeyStroke() -> KeyStroke {
    let stroke = KeyStroke(context: DataController.preview.container.viewContext)
    stroke.unwrappedAction = .press
    stroke.unwrappedKeyCode = .C
    return stroke
}

#Preview {
    KeyStrokeView(stroke: getPreviewKeyStroke())
}
