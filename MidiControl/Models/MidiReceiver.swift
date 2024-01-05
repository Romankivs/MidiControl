//
//  MidiReceiver.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 04.01.2024.
//

import CoreMIDI
import Foundation

extension Data {

    func hexString() -> String {
        if isEmpty { return "" }
        return map { String(format: "%02x", $0) }.joined().uppercased()
    }

}

extension MIDICVStatus: CustomStringConvertible {

    public var description: String {
        switch self {
        // MIDI 1.0
        case .noteOff:
            return "Note Off"
        case .noteOn:
            return "Note On"
        case .polyPressure:
            return "Poly Pressure"
        case .controlChange:
            return "Control Change"
        case .programChange:
            return "Program Change"
        case .channelPressure:
            return "Channel Pressure"
        case .pitchBend:
            return "Pitch Bend"
        // MIDI 2.0
        case .registeredPNC:
            return "Registered PNC"
        case .assignablePNC:
            return "Assignable PNC"
        case .registeredControl:
            return "Registered Control"
        case .assignableControl:
            return "Assignable Control"
        case .relRegisteredControl:
            return "Rel Registered Control"
        case .relAssignableControl:
            return "Rel Assignable Control"
        case .perNotePitchBend:
            return "Per Note PitchBend"
        case .perNoteMgmt:
            return "Per Note Mgmt"
        default:
            return ""
        }
    }
}

extension MIDIEventPacket: CustomStringConvertible {

    var messageType: MIDIMessageType? {
        // Shift the message by 28 bits to get the message type nibble.
        MIDIMessageType(rawValue: words.0 >> 28)
    }

    var hexString: String {
        var data = Data()

        let mirror = Mirror(reflecting: words)
        let elements = mirror.children.map { $0.value }

        for (index, element) in elements.enumerated() {
            guard index < wordCount, let value = element as? UInt32 else { continue }

            withUnsafeBytes(of: UInt32(bigEndian: value)) {
                data.append(contentsOf: $0)
            }
        }

        return data.hexString()
    }

    var status: MIDICVStatus? {
        /*
        To get only the status nibble, shift by 20 bits (the start position of the status)
         and then perform an AND operation to clear the message type and group nibbles.
        */
        return MIDICVStatus(rawValue: (words.0 >> 20) & 0x00f)
    }

    public var description: String {
        guard let messageType = messageType,
              let status = status else {
            return ""
        }

        switch messageType {
        case (.utility):
            return "Utility"
        case (.system):
            return "System"
        case (.channelVoice1):
            return "MIDI 1.0 Channel Voice Message (\(status.description))"
        case (.sysEx):
            return "Sysex"
        case (.channelVoice2):
            return "MIDI 2.0 Channel Voice Message (\(status.description))"
        default:
            return ""
        }
    }
}


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

        status = MIDIInputPortCreateWithProtocol(client, "Midi Receiver" as CFString, ._1_0, &port) { [weak self] eventList, srcConnRefCon in
            print("=== event received")

            guard let strongSelf = self else {
                return
            }

            let midiEventList: MIDIEventList = eventList.pointee
            
            if (midiEventList.numPackets > 0) {
                var packet = midiEventList.packet;
                for _ in 1...midiEventList.numPackets {
                    print(packet.timeStamp)

                    let statusByte = packet.words.0
                    let command = statusByte >> 4  // Get the high-order 4 bits (command)
                    let channel = statusByte & 0x0F  // Get the low-order 4 bits (channel)

                    print("Universal MIDI Packet \(packet.wordCount * 32)")
                    print("Data: 0x\(packet.hexString)")
                    print(packet.description)

                    packet = MIDIEventPacketNext(&packet).pointee;
                }
            }
        }
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
