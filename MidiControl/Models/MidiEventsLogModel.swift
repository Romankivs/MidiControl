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
        request.sortDescriptors = [NSSortDescriptor(key: "created", ascending: true)]
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
                    guard let message = message else { continue }

                    let umpDescription = "[\(currentTime())] \(message.description)"
                    print(umpDescription)
                    self.logs.append(MidiEventDescription(description: umpDescription))

                    switch message {
                    case let .noteOn(channel, note, velocity):
                        self.emulateKeysThatCorespondToMessage(NoteOnMessage.self, "NoteOnMessage") { msg in
                            return (msg.channel - 1 == channel &&
                                    msg.note == note &&
                                    (msg.ignoreVelocity || (msg.minVelocity <= velocity && msg.maxVelocity >= velocity)))
                        }
                    case let .noteOff(channel, note, velocity):
                        self.emulateKeysThatCorespondToMessage(NoteOffMessage.self, "NoteOffMessage") { msg in
                            return (msg.channel - 1 == channel &&
                                    msg.note == note &&
                                    (msg.ignoreVelocity || (msg.minVelocity <= velocity && msg.maxVelocity >= velocity)))
                        }
                    case let .controlChange(channel, index, data):
                        self.emulateKeysThatCorespondToMessage(ControlChangeMessage.self, "ControlChangeMessage") { msg in
                            return (msg.channel - 1 == channel &&
                                    msg.index == index &&
                                    (msg.data == 0 || msg.data == data))
                        }
                    case let .programChange(channel, program):
                        self.emulateKeysThatCorespondToMessage(ProgramChangeMessage.self, "ProgramChangeMessage") { msg in
                            return (msg.channel - 1 == channel &&
                                    (msg.program == 0 || msg.program == program))
                        }
                    case let .channelPressure(channel, data):
                        self.emulateKeysThatCorespondToMessage(ChannelPressureMessage.self, "ChannelPressureMessage") { msg in
                            return (msg.channel - 1 == channel &&
                                    (msg.ignoreData || (msg.minData <= data && msg.maxData >= data)))
                        }
                    case let .polyPressure(channel, note, data):
                        self.emulateKeysThatCorespondToMessage(PolyPressureMessage.self, "PolyPressureMessage") { msg in
                            return (msg.channel - 1 == channel &&
                                    msg.note == note &&
                                    (msg.ignoreData || (msg.minData <= data && msg.maxData >= data)))
                        }
                    case let .pitchBend(channel, data):
                        self.emulateKeysThatCorespondToMessage(PitchBendMessage.self, "PitchBendMessage") { msg in
                            return (msg.channel - 1 == channel &&
                                    (msg.ignoreData || (msg.minData <= data && msg.maxData >= data)))
                        }
                    }
                }
                print("")
            }
        }
    }

    private func emulateKeysThatCorespondToMessage<MessageType: ICDMidiMessage>(_ messageType: MessageType.Type,
                                                                                _ messageName: String,
                                                                                filter: (MessageType) -> Bool) {
        let messages = self.getMessages(name: messageName) as! [MessageType]
        let filtered = messages.filter(filter)
        for msg in filtered {
            let array = msg.keyStrokesArray.sorted { left, right in
                left.createdDate < right.createdDate
            }
            for stroke in array {
                KeyPressEmulator.emulateKey(key: stroke)
            }
        }
    }

    func stopLogTimer() {
        guard let timer = self.timer else { return }

        timer.invalidate()
        self.timer = nil
    }
}
