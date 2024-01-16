//
//  MidiReceiver.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 04.01.2024.
//

import CoreMIDI
import Foundation

class MidiReceiver: ObservableObject {
    init(midiSourcesManager: MidiSourcesManager) {
        self.midiSourcesManager = midiSourcesManager

        if setupMIDI() {
            print("Succesfully started midi client")
        }
        else {
            print("Failed to start midi client")
        }
    }
    
    let midiAdapter = MidiAdapter()

    var midiSourcesManager: MidiSourcesManager

    var client = MIDIClientRef()
    var port = MIDIPortRef()

    var activeSource: MIDIEndpointRef?

    // MARK: - MIDI Setup

    private func setupMIDI() -> Bool {
        var status = MIDIClientCreateWithBlock("Midi Receiver" as CFString, &client, { [weak self] notification in
            self?.handleMIDI(notification)
        })
        guard status == noErr else {
            print("Failed to create the MIDI client.")
            return false
        }

        status = midiAdapter.createMIDISource(client, named: "Midi Receiver" as CFString, protocol: ._1_0, port: &port)
        guard status == noErr else {
            print("Failed to create the MIDI client.")
            return false
        }

        return true
    }

    // MARK: - MIDI Notification

    func handleMIDI(_ notification: UnsafePointer<MIDINotification>) {
        switch notification.pointee.messageID {
        case .msgObjectAdded:
            midiSourcesManager.populateSources()
        case .msgSetupChanged:
            midiSourcesManager.populateSources()
        case .msgObjectRemoved:
            midiSourcesManager.populateSources()
        default:
            return
        }
    }

    func updateSource() {
        if let currentSource = activeSource {
            let status = MIDIPortDisconnectSource(port, currentSource)
            if status != noErr {
                print("Failed to disconnect current source on port")
            }
            else {
                activeSource = nil
            }
        }
        if let nextSource = midiSourcesManager.selectedSource {
            let status = MIDIPortConnectSource(port, nextSource, nil)
            if status != noErr {
                print("Failed to connect to new source on port")
            }
            else {
                activeSource = nextSource
            }
        }
    }
}
