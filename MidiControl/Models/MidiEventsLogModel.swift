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
                        let test = self.getMessages(name: "NoteOnMessage") as! [NoteOnMessage]
                        let search = test.filter { msg in
                            let te = msg.minVelocity <= velocity && msg.maxVelocity >= velocity
                            return (msg.channel - 1 == channel &&
                                    msg.note == note &&
                                    (msg.ignoreVelocity || (msg.minVelocity <= velocity && msg.maxVelocity >= velocity)))
                        }
                        for msg in search {
                            let array = msg.keyStrokesArray.sorted { left, right in
                                left.createdDate < right.createdDate
                            }
                            for stroke in array {
                                KeyPressEmulator.emulateKey(key: stroke)
                            }
                        }
                    case let .noteOff(channel, note, velocity):
                        let test = self.getMessages(name: "NoteOffMessage") as! [NoteOffMessage]
                        let search = test.filter { msg in
                            return (msg.channel - 1 == channel &&
                                    msg.note == note &&
                                    (msg.velocity == 0 || msg.velocity == velocity))
                        }
                        for msg in search {
                            let array = msg.keyStrokesArray.sorted { left, right in
                                left.createdDate < right.createdDate
                            }
                            for stroke in array {
                                KeyPressEmulator.emulateKey(key: stroke)
                            }
                        }
                    case let .controlChange(channel, index, data):
                        let test = self.getMessages(name: "ControlChangeMessage") as! [ControlChangeMessage]
                        let search = test.filter { msg in
                            return (msg.channel - 1 == channel &&
                                    msg.index == index &&
                                    (msg.data == 0 || msg.data == data))
                        }
                        for msg in search {
                            let array = msg.keyStrokesArray.sorted { left, right in
                                left.createdDate < right.createdDate
                            }
                            for stroke in array {
                                KeyPressEmulator.emulateKey(key: stroke)
                           }
                        }
                    case let .programChange(channel, program):
                        let test = self.getMessages(name: "ProgramChangeMessage") as! [ProgramChangeMessage]
                        let search = test.filter { msg in
                            return (msg.channel - 1 == channel &&
                                    (msg.program == 0 || msg.program == program))
                        }
                        for msg in search {
                            let array = msg.keyStrokesArray.sorted { left, right in
                                left.createdDate < right.createdDate
                            }
                            for stroke in array {
                                KeyPressEmulator.emulateKey(key: stroke)
                            }
                        }
                    case let .channelPressure(channel, data):
                        let test = self.getMessages(name: "ChannelPressureMessage") as! [ChannelPressureMessage]
                        let search = test.filter { msg in
                            return (msg.channel - 1 == channel &&
                                    (msg.data == 0 || msg.data == data))
                        }
                        for msg in search {
                            let array = msg.keyStrokesArray.sorted { left, right in
                                left.createdDate < right.createdDate
                            }
                            for stroke in array {
                                KeyPressEmulator.emulateKey(key: stroke)
                            }
                        }
                    case let .polyPressure(channel, note, data):
                        let test = self.getMessages(name: "PolyPressureMessage") as! [PolyPressureMessage]
                        let search = test.filter { msg in
                            return (msg.channel - 1 == channel &&
                                    msg.note == note &&
                                    (msg.data == 0 || msg.data == data))
                        }
                        for msg in search {
                            let array = msg.keyStrokesArray.sorted { left, right in
                                left.createdDate < right.createdDate
                            }
                            for stroke in array {
                                KeyPressEmulator.emulateKey(key: stroke)
                            }
                        }
                    case let .pitchBend(channel, data):
                        let test = self.getMessages(name: "PitchBendMessage") as! [PitchBendMessage]
                        let search = test.filter { msg in
                            return (msg.channel - 1 == channel &&
                                    (msg.data == 0 || msg.data == data))
                        }
                        for msg in search {
                            let array = msg.keyStrokesArray.sorted { left, right in
                                left.createdDate < right.createdDate
                            }
                            for stroke in array {
                                KeyPressEmulator.emulateKey(key: stroke)
                            }
                        }
                    }
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
