//
//  MidiSourcesManager.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 30.12.2023.
//

import Foundation
import CoreMIDI

class MidiSourcesManager: ObservableObject {
    @Published var midiSources = [MIDIEndpointModel]()

    @Published var selectedSourceIndex = 0
    var selectedSource: MIDIEndpointRef? {
        if selectedSourceIndex < 0 || selectedSourceIndex >= midiSources.count { return nil }
        return midiSources[selectedSourceIndex].endpointType
    }

    init() {
        populateSources()
    }

    func populateSources() {
        midiSources.removeAll()

        for index in 0..<MIDIGetNumberOfSources() {
            let endpoint = MIDIGetSource(index)

            var sourceName: Unmanaged<CFString>?
            var protocolID = Int32()

            if MIDIObjectGetStringProperty(endpoint, kMIDIPropertyDisplayName, &sourceName) == noErr,
               MIDIObjectGetIntegerProperty(endpoint, kMIDIPropertyProtocolID, &protocolID) == noErr,
                let protocolID = MIDIProtocolID(rawValue: protocolID) {
                let name = "\(sourceName!.takeRetainedValue() as String) (\(protocolID.description))"

                let source = MIDIEndpointModel(endpointType: endpoint, name: name, protocolID: protocolID)
                midiSources.append(source)
            }
        }
    }

}
