//
//  MidiMessageViews.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 12.01.2024.
//

import SwiftUI

struct MidiMessageView: View {
    var model: NSManagedObject

    var body: some View {
        HStack {
            switch model {
            case let model as NoteOnMessage:
                MidiNoteOnView(model: model)
            case let model as NoteOffMessage:
                MidiNoteOffView(model: model)
//            case .noteOff(let channel, let note, let velocity):
//                <#code#>
//            case .polyPressure(let channel, let noteNumber, let data):
//                <#code#>
//            case .controlChange(let channel, let index, let data):
//                <#code#>
//            case .programChange(let channe, let program):
//                <#code#>
//            case .channelPressure(let channel, let data):
//                <#code#>
//            case .pitchBend(let channel, let lsbData, let msbData):
//                <#code#>
            default: Text("Unknown message")
            }
        }
        .padding(.horizontal, 3.0)
    }
}

struct MidiNoteOnView: View {
    @ObservedObject var model: NoteOnMessage

    @Environment(\.managedObjectContext) var moc

    var body: some View {
        HStack {
            Text("Note On").fontWeight(.bold)
            TextFieldUInt8(value: $model.channel, name: "Channel", emptyText: "Enter channel number")
            TextFieldUInt8(value: $model.note, name: "Note", emptyText: "Enter note number")
            TextFieldUInt8(value: $model.velocity, name: "Velocity", emptyText: "Enter velocity value")
        }
        .onChange(of: [model.channel, model.note, model.velocity]) { _ in
            try? moc.save()
        }
    }
}

struct MidiNoteOffView: View {
    @ObservedObject var model: NoteOffMessage

    @Environment(\.managedObjectContext) var moc

    var body: some View {
        HStack {
            Text("Note Off").fontWeight(.bold)
            TextFieldUInt8(value: $model.channel, name: "Channel", emptyText: "Enter channel number")
            TextFieldUInt8(value: $model.note, name: "Note", emptyText: "Enter note number")
            TextFieldUInt8(value: $model.velocity, name: "Velocity", emptyText: "Enter velocity value")
        }
        .onChange(of: [model.channel, model.note, model.velocity]) { _ in
            try? moc.save()
        }
    }
}

func getMessage() -> NoteOnMessage {
    var noteOn = NoteOnMessage()
    noteOn.channel = 3
    noteOn.note = 55
    noteOn.velocity = 100
    return noteOn
}

#Preview {
    List {
        MidiMessageView(model: getMessage())
        MidiMessageView(model: getMessage())
    }
}
