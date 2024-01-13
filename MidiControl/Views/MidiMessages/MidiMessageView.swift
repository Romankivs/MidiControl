//
//  MidiMessageViews.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 12.01.2024.
//

import SwiftUI

struct MidiMessageView: View {
    var model: IMidiMessage

    var body: some View {
        HStack {
            switch model {
            case let model as MidiNoteOnMessage:
                MidiNoteOnView(model: model)
            case let model as MidiNoteOffMessage:
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
    @ObservedObject var model: MidiNoteOnMessage

    var body: some View {
        HStack {
            Text("Note On").fontWeight(.bold)
            TextFieldUInt8(value: $model.channel, name: "Channel", emptyText: "Enter channel number")
            TextFieldUInt8(value: $model.note, name: "Note", emptyText: "Enter note number")
            TextFieldUInt8(value: $model.velocity, name: "Velocity", emptyText: "Enter velocity value")
        }
    }
}

struct MidiNoteOffView: View {
    @ObservedObject var model: MidiNoteOffMessage

    var body: some View {
        HStack {
            Text("Note Off").fontWeight(.bold)
            TextFieldUInt8(value: $model.channel, name: "Channel", emptyText: "Enter channel number")
            TextFieldUInt8(value: $model.note, name: "Note", emptyText: "Enter note number")
        }
    }
}

#Preview {
    List {
        MidiMessageView(model: MidiNoteOnMessage(channel: 5, note: 22, velocity: 126))
        MidiMessageView(model: MidiNoteOffMessage(channel: 11, note: 120, velocity: 123))
    }
}
