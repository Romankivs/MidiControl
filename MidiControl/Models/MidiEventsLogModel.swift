//
//  MidiEventsLogger.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 06.01.2024.
//

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

                self.logs.append(MidiEventDescription(description: packet.description))
            }
        }
    }

    func stopLogTimer() {
        guard let timer = self.timer else { return }

        timer.invalidate()
        self.timer = nil
    }
}
