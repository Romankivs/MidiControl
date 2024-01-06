//
//  MidiReceiver.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 04.01.2024.
//

import CoreMIDI
import Foundation

class MidiReceiver {
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

    var timer: Timer?

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

    // MARK: - Timer Callback

    func startLogTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self else { return }

            self.midiAdapter.popSourceMessages { packet in
                print("------------------------------------")
                print("Universal MIDI Packet \(packet.wordCount * 32)")
                print("Data: 0x\(packet.hexString)")
                print(packet.description)
                print("")
            }
        }
    }

    func stopLogTimer() {
        guard let timer = self.timer else { return }

        timer.invalidate()
        self.timer = nil
    }
}
