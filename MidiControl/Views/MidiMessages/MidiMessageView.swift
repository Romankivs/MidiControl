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
            case let model as ControlChangeMessage:
                MidiControlChangeView(model: model)
            case let model as ProgramChangeMessage:
                MidiProgramChangeView(model: model)
            case let model as ChannelPressureMessage:
                MidiChannelPressureView(model: model)
            case let model as PolyPressureMessage:
                MidiPolyPressureView(model: model)
            case let model as PitchBendMessage:
                MidiPitchBendView(model: model)
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
            ChannelStepper(value: $model.channel)
            TextFieldUInt8(value: $model.note, name: "Note", emptyText: "Enter note number")
            VStack {
                Toggle(isOn: $model.ignoreVelocity) {
                }.labelsHidden()
                Text("Ignore Velocity")
            }
            TextFieldUInt8(value: $model.minVelocity, name: "Min Velocity", emptyText: "Enter velocity value")
                .disabled(model.ignoreVelocity)
            TextFieldUInt8(value: $model.maxVelocity, name: "Max Velocity", emptyText: "Enter velocity value")
                .disabled(model.ignoreVelocity)
        }
        .onChange(of: [model.channel, model.note, model.minVelocity, model.maxVelocity]) { _ in
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
            ChannelStepper(value: $model.channel)
            TextFieldUInt8(value: $model.note, name: "Note", emptyText: "Enter note number")
            TextFieldUInt8(value: $model.velocity, name: "Velocity", emptyText: "Enter velocity value")
        }
        .onChange(of: [model.channel, model.note, model.velocity]) { _ in
            try? moc.save()
        }
    }
}

struct MidiControlChangeView: View {
    @ObservedObject var model: ControlChangeMessage

    @Environment(\.managedObjectContext) var moc

    var body: some View {
        HStack {
            Text("Control Change").fontWeight(.bold)
            ChannelStepper(value: $model.channel)
            TextFieldUInt8(value: $model.index, name: "Index", emptyText: "Enter index")
            TextFieldUInt8(value: $model.data, name: "Data", emptyText: "Enter data value")
        }
        .onChange(of: [model.channel, model.index, model.data]) { _ in
            try? moc.save()
        }
    }
}

struct MidiProgramChangeView: View {
    @ObservedObject var model: ProgramChangeMessage

    @Environment(\.managedObjectContext) var moc

    var body: some View {
        HStack {
            Text("Program Change").fontWeight(.bold)
            ChannelStepper(value: $model.channel)
            TextFieldUInt8(value: $model.program, name: "Program", emptyText: "Enter program value")
        }
        .onChange(of: [model.channel, model.program]) { _ in
            try? moc.save()
        }
    }
}

struct MidiChannelPressureView: View {
    @ObservedObject var model: ChannelPressureMessage

    @Environment(\.managedObjectContext) var moc

    var body: some View {
        HStack {
            Text("Channel Pressure").fontWeight(.bold)
            ChannelStepper(value: $model.channel)
            TextFieldUInt8(value: $model.data, name: "Data", emptyText: "Enter data value")
        }
        .onChange(of: [model.channel, model.data]) { _ in
            try? moc.save()
        }
    }
}

struct MidiPolyPressureView: View {
    @ObservedObject var model: PolyPressureMessage

    @Environment(\.managedObjectContext) var moc

    var body: some View {
        HStack {
            Text("Channel Pressure").fontWeight(.bold)
            ChannelStepper(value: $model.channel)
            TextFieldUInt8(value: $model.note, name: "Note", emptyText: "Enter note number")
            TextFieldUInt8(value: $model.data, name: "Data", emptyText: "Enter data value")
        }
        .onChange(of: [model.channel, model.note, model.data]) { _ in
            try? moc.save()
        }
    }
}

struct MidiPitchBendView: View {
    @ObservedObject var model: PitchBendMessage

    @Environment(\.managedObjectContext) var moc

    var body: some View {
        HStack {
            Text("Channel Pressure").fontWeight(.bold)
            ChannelStepper(value: $model.channel)
            TextFieldUInt16(value: $model.data, name: "Data", emptyText: "Enter data value")
        }
        .onChange(of: model.channel) { _ in
            try? moc.save()
        }
        .onChange(of: model.data) { _ in
            try? moc.save()
        }
    }
}

func getPreviewMessage() -> NoteOnMessage {
    let noteOn = NoteOnMessage(context: DataController.preview.container.viewContext)
    noteOn.channel = 3
    noteOn.note = 55
    noteOn.minVelocity = 100
    noteOn.maxVelocity = 125
    return noteOn
}

#Preview {
    List {
        MidiMessageView(model: getPreviewMessage())
        MidiMessageView(model: getPreviewMessage())
    }
    .environment(\.managedObjectContext, DataController.preview.container.viewContext)
}
