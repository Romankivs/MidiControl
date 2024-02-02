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
    case polyPressure(channel: UInt8, note: UInt8, data: UInt8)
    case controlChange(channel: UInt8, index: UInt8, data: UInt8)
    case programChange(channel: UInt8, program: UInt8)
    case channelPressure(channel: UInt8, data: UInt8)
    case pitchBend(channel: UInt8, data: UInt16)
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
        case .controlChange:
            self = .controlChange(channel: UInt8(extractBits(from: umpWord, at: 16, numberOfBits: 4)),
                           index: UInt8(extractBits(from: umpWord, at: 8, numberOfBits: 8)),
                           data: UInt8(extractBits(from: umpWord, at: 0, numberOfBits: 8)))
        case .programChange:
            self = .programChange(channel: UInt8(extractBits(from: umpWord, at: 16, numberOfBits: 4)),
                           program: UInt8(extractBits(from: umpWord, at: 8, numberOfBits: 8)))
        case .channelPressure:
            self = .channelPressure(channel: UInt8(extractBits(from: umpWord, at: 16, numberOfBits: 4)),
                           data: UInt8(extractBits(from: umpWord, at: 8, numberOfBits: 8)))
        case .polyPressure:
            self = .polyPressure(channel: UInt8(extractBits(from: umpWord, at: 16, numberOfBits: 4)),
                           note: UInt8(extractBits(from: umpWord, at: 8, numberOfBits: 8)),
                           data: UInt8(extractBits(from: umpWord, at: 0, numberOfBits: 8)))
        case .pitchBend:
            let msb = extractBits(from: umpWord, at: 0, numberOfBits: 7)
            let lsb = extractBits(from: umpWord, at: 8, numberOfBits: 7)
            self = .pitchBend(channel: UInt8(extractBits(from: umpWord, at: 16, numberOfBits: 4)),
                           data: (UInt16(msb) << 7) | UInt16(lsb))
        default:
            return nil
        }
    }
}

extension MidiMessage : CustomStringConvertible {
    var description: String {
        return switch self {
        case let .noteOn(channel, note, velocity): "Note On | Channel: \(channel) Note: \(note) Velocity: \(velocity)"
        case let .noteOff(channel, note, velocity): "Note Off | Channel: \(channel) Note: \(note) Velocity: \(velocity)"
        case let .controlChange(channel, index, data): "Control Change | Channel: \(channel) Index: \(index) Data: \(data)"
        case let .programChange(channel, program): "Program Change | Channel: \(channel) Program: \(program)"
        case let .channelPressure(channel, data): "Channel Presure | Channel: \(channel) Data: \(data)"
        case let .polyPressure(channel, note, data): "Poly Presure | Channel: \(channel) Note: \(note) Data: \(data)"
        case let .pitchBend(channel, data): "Pitch Bend | Channel: \(channel) Data: \(data)"
        }
    }
}

protocol IMidiMessage {
    var description: String { get }
}

func getMidiMessageFromUmp(umpWord: UInt32) -> (any IMidiMessage)? {
    switch statusFromUMP(ump: umpWord) {
    case .noteOn:
        return MidiNoteOnMessage(channel: UInt8(extractBits(from: umpWord, at: 16, numberOfBits: 4)),
                       note: UInt8(extractBits(from: umpWord, at: 8, numberOfBits: 8)),
                       velocity: UInt8(extractBits(from: umpWord, at: 0, numberOfBits: 8)))
//    case .noteOff:
//        return MidiNoteOffMessage(channel: UInt8(extractBits(from: umpWord, at: 16, numberOfBits: 4)),
//                       note: UInt8(extractBits(from: umpWord, at: 8, numberOfBits: 8)),
//                       velocity: UInt8(extractBits(from: umpWord, at: 0, numberOfBits: 8)))
    default:
        return nil
    }
}

class MidiNoteOnMessage: IMidiMessage, ObservableObject {
    init(channel: UInt8, note: UInt8, velocity: UInt8) {
        self.channel = channel
        self.note = note
        self.velocity = velocity
    }
    
    @Published var channel: UInt8
    @Published var note: UInt8
    @Published var velocity: UInt8

    var description: String {
        return "Channel: \(channel) Note: \(note) Velocity: \(velocity)"
    }
}

class MidiNoteOffMessage: IMidiMessage, ObservableObject {
    init(channel: UInt8, note: UInt8, velocity: UInt8) {
        self.channel = channel
        self.note = note
        self.velocity = velocity
    }

    @Published var channel: UInt8
    @Published var note: UInt8
    @Published var velocity: UInt8

    var description: String {
        return "Channel: \(channel) Note: \(note) Velocity: \(velocity)"
    }
}


//
//class MidiNoteOffMessage: IMidiMessage {
//    @State var channel: UInt8
//    @State var note: UInt8
//    @State var velocity: UInt8
//
//    var description: String {
//        return "Channel: \(channel) Note: \(note) Velocity: \(velocity)"
//    }
//
//    var body: some View  {
//        HStack {
//            Text("Note Off").padding()
//            TextEntryField(value: $channel, name: "Channel", emptyText: "Enter channel")
//            TextEntryField(value: $note, name: "Note", emptyText: "Enter note")
//            TextEntryField(value: $velocity, name: "Velocity", emptyText: "Enter velocity")
//        }
//    }
//}
//
//struct MidiPolyPressureMessage : IMidiMessage {
//    @State var channel: UInt8
//    @State var note: UInt8
//    @State var data: UInt8
//
//    var description: String {
//        return "Channel: \(channel) Note: \(note) Data: \(data)"
//    }
//
//    var body: some View  {
//        HStack {
//            Text("Note Off").padding()
//            TextEntryField(value: $channel, name: "Channel", emptyText: "Enter channel")
//            TextEntryField(value: $note, name: "Note", emptyText: "Enter note")
//            TextEntryField(value: $data, name: "Data", emptyText: "Enter data")
//        }
//    }
//}
//
