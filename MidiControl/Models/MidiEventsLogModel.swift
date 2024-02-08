//
//  MidiEventsLogger.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 06.01.2024.
//

import CoreData
import AppKit

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

func terminateApplication(bundleIdentifier: String) {
    let scriptSource = "tell application \"\(bundleIdentifier)\" to quit"
    var error: NSDictionary?

    print(scriptSource)

    if let script = NSAppleScript(source: scriptSource) {
        script.executeAndReturnError(&error)
        if let error = error {
            print("Error terminating application: \(error)")
        }
    }
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
                        self.triggerEventsThatCorespondToMessage(NoteOnMessage.self, "NoteOnMessage") { msg in
                            return (msg.channel - 1 == channel &&
                                    msg.note == note &&
                                    (msg.ignoreVelocity || (msg.minVelocity <= velocity && msg.maxVelocity >= velocity)))
                        }
                    case let .noteOff(channel, note, velocity):
                        self.triggerEventsThatCorespondToMessage(NoteOffMessage.self, "NoteOffMessage") { msg in
                            return (msg.channel - 1 == channel &&
                                    msg.note == note &&
                                    (msg.ignoreVelocity || (msg.minVelocity <= velocity && msg.maxVelocity >= velocity)))
                        }
                    case let .controlChange(channel, index, data):
                        self.triggerEventsThatCorespondToMessage(ControlChangeMessage.self, "ControlChangeMessage") { msg in
                            return (msg.channel - 1 == channel &&
                                    msg.index == index &&
                                    (msg.data == 0 || msg.data == data))
                        }
                    case let .programChange(channel, program):
                        self.triggerEventsThatCorespondToMessage(ProgramChangeMessage.self, "ProgramChangeMessage") { msg in
                            return (msg.channel - 1 == channel &&
                                    (msg.program == 0 || msg.program == program))
                        }
                    case let .channelPressure(channel, data):
                        self.triggerEventsThatCorespondToMessage(ChannelPressureMessage.self, "ChannelPressureMessage") { msg in
                            return (msg.channel - 1 == channel &&
                                    (msg.ignoreData || (msg.minData <= data && msg.maxData >= data)))
                        }
                    case let .polyPressure(channel, note, data):
                        self.triggerEventsThatCorespondToMessage(PolyPressureMessage.self, "PolyPressureMessage") { msg in
                            return (msg.channel - 1 == channel &&
                                    msg.note == note &&
                                    (msg.ignoreData || (msg.minData <= data && msg.maxData >= data)))
                        }
                    case let .pitchBend(channel, data):
                        self.triggerEventsThatCorespondToMessage(PitchBendMessage.self, "PitchBendMessage") { msg in
                            return (msg.channel - 1 == channel &&
                                    (msg.ignoreData || (msg.minData <= data && msg.maxData >= data)))
                        }
                    }
                }
                print("")
            }
        }
    }

    private func triggerEventsThatCorespondToMessage<MessageType: ICDMidiMessage>(_ messageType: MessageType.Type,
                                                                                _ messageName: String,
                                                                                filter: (MessageType) -> Bool) {
        let messages = self.getMessages(name: messageName) as! [MessageType]
        let filtered = messages.filter(filter)
        for msg in filtered {
            let array = msg.triggerableEventsArray.sorted { left, right in
                left.createdDate < right.createdDate
            }
            Task.detached {
                array.forEach(self.triggerEvent)
            }
        }
    }

    private func triggerEvent(event: TriggerableEvent) {
        if let keyStroke = event as? KeyStroke {
            KeyPressEmulator.emulateKey(key: keyStroke)
        }
        else if let appLaunch = event as? ApplicationLaunch, let url = appLaunch.unwrappedUrl {
            let configuration = NSWorkspace.OpenConfiguration()
            configuration.activates = appLaunch.activates
            configuration.hidesOthers = appLaunch.hidesOthers
            configuration.createsNewApplicationInstance = appLaunch.newInstance
            NSWorkspace.shared.openApplication(at: url, configuration: configuration)
        }
        else if let appLaunch = event as? ApplicationClosure, let url = appLaunch.unwrappedUrl {
            let runningApps = NSWorkspace.shared.runningApplications
            for app in runningApps {
               if let bundleUrl = app.bundleURL, bundleUrl == url {
                   terminateApplication(bundleIdentifier: bundleUrl.lastPathComponent)
               }
            }
        }
        else if let delay = event as? DelayEvent {
            usleep(UInt32(delay.amountMilliseconds * 1000)) // 1000 microseconds is 1 millisecond
        }
    }

    func stopLogTimer() {
        guard let timer = self.timer else { return }

        timer.invalidate()
        self.timer = nil
    }
}
