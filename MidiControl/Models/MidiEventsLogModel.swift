//
//  MidiEventsLogger.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 06.01.2024.
//

func extractBits(from number: UInt32, at position: Int, numberOfBits: Int) -> UInt32 {
    // Ensure that the position and number of bits are within valid ranges
    guard position >= 0 && position <= 32 && numberOfBits > 0 && numberOfBits <= 32 else {
        fatalError("Invalid position or number of bits.")
    }

    // Mask the desired bits at the specified position
    let mask: UInt32 = (1 << numberOfBits) - 1
    let maskedValue = (number >> position) & mask

    return maskedValue
}

func statusFromUMP(ump: UInt32) -> MIDICVStatus {
    return MIDICVStatus(rawValue: extractBits(from: ump, at: 20, numberOfBits: 4)) ?? .noteOff
}

struct Midi1NoteOnMessage : CustomStringConvertible {
    init(ump: UInt32) {
        channel = UInt8(extractBits(from: ump, at: 16, numberOfBits: 4))
        note = UInt8(extractBits(from: ump, at: 8, numberOfBits: 8))
        velocity = UInt8(extractBits(from: ump, at: 0, numberOfBits: 8))
    }

    var description: String {
        return "Channel: \(channel) Note: \(note) Velocity: \(velocity)"
    }

    var channel: UInt8
    var note: UInt8
    var velocity: UInt8
}

struct Midi1NoteOffMessage: CustomStringConvertible {
    init(ump: UInt32) {
        channel = UInt8(extractBits(from: ump, at: 16, numberOfBits: 4))
        note = UInt8(extractBits(from: ump, at: 8, numberOfBits: 8))
        velocity = UInt8(extractBits(from: ump, at: 0, numberOfBits: 8))
    }

    var description: String {
        return "Channel: \(channel) Note: \(note) Velocity: \(velocity)"
    }

    var channel: UInt8
    var note: UInt8
    var velocity: UInt8
}

func currentTime() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm:ss.SS"

    let date = Date()

    return dateFormatter.string(from: date)
}

struct MidiEventDescription: Identifiable {
    let description: String
    let id = UUID()
}

class MidiEventsLogModel: ObservableObject {
    init(midiAdapter: MidiAdapter = .init()) {
        self.midiAdapter = midiAdapter
    }
    
    var timer: Timer?

    var midiAdapter: MidiAdapter

    @Published var logs: [MidiEventDescription] = []

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
                
                for umpPacket in packet.wordsArray {
                    var message: CustomStringConvertible?

                    switch statusFromUMP(ump: umpPacket) {
                    case .noteOn:
                        message = Midi1NoteOnMessage(ump: umpPacket)
                    case .noteOff:
                        message = Midi1NoteOffMessage(ump: umpPacket)
                    default:
                        continue
                    }

                    let umpDescription = "[\(currentTime())] \(message!.description)"
                    print(umpDescription)
                    self.logs.append(MidiEventDescription(description: umpDescription))
                }
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
