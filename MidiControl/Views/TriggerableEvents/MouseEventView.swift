//
//  MidiEventView.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 09.02.2024.
//

import SwiftUI

struct MouseEventView: View {
    @ObservedObject var mouse: MouseEvent

    @Environment(\.managedObjectContext) var moc

    var body: some View {
        HStack {
            Text("Mouse Event").bold().padding(.horizontal)
            Picker("Type", selection: $mouse.unwrappedType) {
                ForEach(MouseEventType.allCases) { code in
                    Text(code.description)
                }
            }
            .padding(.horizontal)
            .labelsHidden()
            TextFieldDouble(value: $mouse.mousePositionX,
                            name: "Position X",
                            emptyText: "Enter position x",
                            maximum: 15000)
            TextFieldDouble(value: $mouse.mousePositionY,
                            name: "Position Y",
                            emptyText: "Enter position y",
                            maximum: 15000)
            TextFieldUInt16(value: $mouse.otherButton,
                            name: "Other Button",
                            emptyText: "Enter other button",
                            minimum: 3,
                            maximum: 31)
        }
        .onChange(of: [mouse.action, mouse.otherButton]) { _ in
            try? moc.save()
        }
        .onChange(of: [mouse.mousePositionX, mouse.mousePositionY]) { _ in
            try? moc.save()
        }
    }
}

func getPreviewMouseEvent() -> MouseEvent {
    let stroke = MouseEvent(context: DataController.preview.container.viewContext)
    stroke.unwrappedType = .move
    stroke.mousePositionX = 500
    stroke.mousePositionY = 600
    stroke.otherButton = 1
    return stroke
}

#Preview {
    MouseEventView(mouse: getPreviewMouseEvent())
}
