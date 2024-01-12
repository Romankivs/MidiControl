//
//  MidiMessage.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 09.01.2024.
//

import Foundation
import SwiftUI

enum MidiMessage {
    // MIDI 1
    case noteOn(channel: UInt8, note: UInt8, velocity: UInt8)
    case noteOff(channel: UInt8, note: UInt8, velocity: UInt8)
    case polyPressure(channel: UInt8, noteNumber: UInt8, data: UInt8)
    case controlChange(channel: UInt8, index: UInt8, data: UInt8)
    case programChange(channe: UInt8, program: UInt8)
    case channelPressure(channel: UInt8, data: UInt8)
    case pitchBend(channel: UInt8, lsbData: UInt8, msbData: UInt8)
}

extension MidiMessage {
    init?(umpWord: UInt32) {
        switch statusFromUMP(ump: umpWord) {
        case .noteOn:
            self = .noteOn(channel: UInt8(extractBits(from: umpWord, at: 16, numberOfBits: 4)),
                           note: UInt8(extractBits(from: umpWord, at: 8, numberOfBits: 8)),
                           velocity: UInt8(extractBits(from: umpWord, at: 0, numberOfBits: 8)))
        case .noteOff:
            self = .noteOff(channel: UInt8(extractBits(from: umpWord, at: 16, numberOfBits: 4)),
                           note: UInt8(extractBits(from: umpWord, at: 8, numberOfBits: 8)),
                           velocity: UInt8(extractBits(from: umpWord, at: 0, numberOfBits: 8)))
        default:
            return nil
        }
    }
}

extension MidiMessage : CustomStringConvertible {
    var description: String {
        return switch self {
        case let .noteOn(channel, note, velocity): "Channel: \(channel) Note: \(note) Velocity: \(velocity)"
        case let .noteOff(channel, note, velocity): "Channel: \(channel) Note: \(note) Velocity: \(velocity)"
        default: "Unknown message"
        }
    }
}

protocol IMidiMessage: View {
    var description: String { get }
}

func getMidiMessageFromUmp(umpWord: UInt32) -> (any IMidiMessage)? {
    switch statusFromUMP(ump: umpWord) {
    case .noteOn:
        return MidiNoteOnMessage(channel: UInt8(extractBits(from: umpWord, at: 16, numberOfBits: 4)),
                       note: UInt8(extractBits(from: umpWord, at: 8, numberOfBits: 8)),
                       velocity: UInt8(extractBits(from: umpWord, at: 0, numberOfBits: 8)))
    case .noteOff:
        return MidiNoteOffMessage(channel: UInt8(extractBits(from: umpWord, at: 16, numberOfBits: 4)),
                       note: UInt8(extractBits(from: umpWord, at: 8, numberOfBits: 8)),
                       velocity: UInt8(extractBits(from: umpWord, at: 0, numberOfBits: 8)))
    default:
        return nil
    }
}

struct TextEntryField : View {
    var value: Binding<UInt8>
    var name: String
    var emptyText: String

    var body: some View {
        HStack {
            Text(name)
            TextField(emptyText, value: value, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }.padding()
    }
}

struct MidiNoteOnMessage: IMidiMessage {
    @State var channel: UInt8
    @State var note: UInt8
    @State var velocity: UInt8

    var description: String {
        return "Channel: \(channel) Note: \(note) Velocity: \(velocity)"
    }

    var body: some View {
        HStack {
            Text("Note On").padding()
            TextEntryField(value: $channel, name: "Channel", emptyText: "Enter channel number")
            TextEntryField(value: $note, name: "Note", emptyText: "Enter note number")
            TextEntryField(value: $velocity, name: "Velocity", emptyText: "Enter velocity value")
        }
    }
}

struct MidiNoteOffMessage: IMidiMessage {
    @State var channel: UInt8
    @State var note: UInt8
    @State var velocity: UInt8

    var description: String {
        return "Channel: \(channel) Note: \(note) Velocity: \(velocity)"
    }

    var body: some View  {
        HStack {
            Text("Note Off").padding()
            TextEntryField(value: $channel, name: "Channel", emptyText: "Enter channel")
            TextEntryField(value: $note, name: "Note", emptyText: "Enter note")
            TextEntryField(value: $velocity, name: "Velocity", emptyText: "Enter velocity")
        }
    }
}

struct MidiPolyPressureMessage : IMidiMessage {
    @State var channel: UInt8
    @State var note: UInt8
    @State var data: UInt8

    var description: String {
        return "Channel: \(channel) Note: \(note) Data: \(data)"
    }

    var body: some View  {
        HStack {
            Text("Note Off").padding()
            TextEntryField(value: $channel, name: "Channel", emptyText: "Enter channel")
            TextEntryField(value: $note, name: "Note", emptyText: "Enter note")
            TextEntryField(value: $data, name: "Data", emptyText: "Enter data")
        }
    }
}


#Preview {
    List {
        MidiNoteOnMessage(channel: 5, note: 22, velocity: 126)
        MidiNoteOffMessage(channel: 11, note: 100, velocity: 1)
    }
}
