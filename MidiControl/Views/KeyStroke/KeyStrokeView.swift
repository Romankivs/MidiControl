//
//  KeyStrokeView.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 18.01.2024.
//

import SwiftUI

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
            Picker("Key", selection: $stroke.unwrappedKeyCode) {
                ForEach(KeyCode.allCases) { code in
                    Text(code.description)
                }
            }
            .padding(.horizontal)
            Toggle(isOn: $stroke.command) {
                Image(systemName: "command")
            }.padding(.horizontal)
            Toggle(isOn: $stroke.option) {
                Image(systemName: "option")
            }.padding(.horizontal)
            Toggle(isOn: $stroke.control) {
                Image(systemName: "control")
            }.padding(.horizontal)
            Toggle(isOn: $stroke.shift) {
                Image(systemName: "shift")
            }.padding(.horizontal)
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
