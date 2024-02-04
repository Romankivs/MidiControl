//
//  MidiEndpointModel.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 30.12.2023.
//

import Foundation
import CoreMIDI

extension MIDIProtocolID: CustomStringConvertible {
    public var description: String {
        switch self {
        case ._1_0:
            return "MIDI-1UP"
        case ._2_0:
            return "MIDI 2.0"
        default:
            return "N/A"
        }
    }
}

struct MIDIEndpointModel: Identifiable, Hashable {
    let id = UUID()

    let endpointType: MIDIEndpointRef
    let name: String
    let image: String
    let protocolID: MIDIProtocolID

    var protocolName: String {
        protocolID.description
    }
}
