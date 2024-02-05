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
