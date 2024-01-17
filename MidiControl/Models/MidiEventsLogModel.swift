//
//  MidiEventsLogger.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 06.01.2024.
//

import CoreData

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
    init(midiAdapter: MidiAdapter = .init(), context: NSManagedObjectContext) {
        self.midiAdapter = midiAdapter
        self.context = context
    }

    @Published var logs: [MidiEventDescription] = []

    private var timer: Timer?

    private var midiAdapter: MidiAdapter

    private var context: NSManagedObjectContext

    func getMessages<T: NSManagedObject>(name: String) -> [T] {
        let request = NSFetchRequest<T>(entityName: name)
        return (try? context.fetch(request)) ?? []
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
                
                for umpPacket in packet.wordsArray {
                    let message = MidiMessage(umpWord: umpPacket)
                    
                    let umpDescription = "[\(currentTime())] \(message!.description)"
                    print(umpDescription)
                    self.logs.append(MidiEventDescription(description: umpDescription))

                    let test = self.getMessages(name: "NoteOffMessage")
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
