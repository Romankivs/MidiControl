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

    @Published var selectedSourcesNames: Set<String> = []
    var selectedSources: [MIDIEndpointRef] {
        let filtered = midiSources.filter { selectedSourcesNames.contains($0.name) }
        let endpoints = filtered.map { $0.endpointType }
        return endpoints
    }

    init() {
        populateSources()
    }

    func populateSources() {
        midiSources.removeAll()

        for index in 0..<MIDIGetNumberOfSources() {
            let endpoint = MIDIGetSource(index)

            var sourceName: Unmanaged<CFString>?
            var sourceIcon: Unmanaged<CFString>?
            var protocolID = Int32()

            let imageRes = MIDIObjectGetStringProperty(endpoint, kMIDIPropertyImage, &sourceIcon)

            if MIDIObjectGetStringProperty(endpoint, kMIDIPropertyDisplayName, &sourceName) == noErr,
               MIDIObjectGetIntegerProperty(endpoint, kMIDIPropertyProtocolID, &protocolID) == noErr,
                let protocolID = MIDIProtocolID(rawValue: protocolID) {
                let name = "\(sourceName!.takeRetainedValue() as String) (\(protocolID.description))"
                let image = imageRes == noErr ? sourceIcon!.takeRetainedValue() as String : ""

                let source = MIDIEndpointModel(endpointType: endpoint, name: name, image: image, protocolID: protocolID)
                midiSources.append(source)
            }
        }
    }

}
