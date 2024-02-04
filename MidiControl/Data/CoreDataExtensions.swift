//
//  CDExtensions.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 16.01.2024.
//

import Foundation

// MARK: MIDI Messages extensions

protocol CreatedAtDate {
    var createdDate: Date { get set }
}

protocol ICDMidiMessage: CreatedAtDate {
    var triggerableEventsArray: [TriggerableEvent] { get }
}

extension NoteOnMessage: ICDMidiMessage {
    var createdDate: Date {
        get {
            created ?? .distantPast
        }
        set {
            created = newValue
        }
    }
    
    public var triggerableEventsArray: [TriggerableEvent] {
        guard let event = event else { return [] }
        return Array(event as! Set<TriggerableEvent>)
    }
}

extension NoteOffMessage: ICDMidiMessage {
    var createdDate: Date {
        get {
            created ?? .distantPast
        }
        set {
            created = newValue
        }
    }

    public var triggerableEventsArray: [TriggerableEvent] {
        guard let event = event else { return [] }
        return Array(event as! Set<TriggerableEvent>)
    }
}

extension ControlChangeMessage: ICDMidiMessage {
    var createdDate: Date {
        get {
            created ?? .distantPast
        }
        set {
            created = newValue
        }
    }

    public var triggerableEventsArray: [TriggerableEvent] {
        guard let event = event else { return [] }
        return Array(event as! Set<TriggerableEvent>)
    }
}

extension ProgramChangeMessage: ICDMidiMessage {
    var createdDate: Date {
        get {
            created ?? .distantPast
        }
        set {
            created = newValue
        }
    }

    public var triggerableEventsArray: [TriggerableEvent] {
        guard let event = event else { return [] }
        return Array(event as! Set<TriggerableEvent>)
    }

}

extension ChannelPressureMessage: ICDMidiMessage {
    var createdDate: Date {
        get {
            created ?? .distantPast
        }
        set {
            created = newValue
        }
    }

    public var triggerableEventsArray: [TriggerableEvent] {
        guard let event = event else { return [] }
        return Array(event as! Set<TriggerableEvent>)
    }

}

extension PolyPressureMessage: ICDMidiMessage {
    var createdDate: Date {
        get {
            created ?? .distantPast
        }
        set {
            created = newValue
        }
    }

    public var triggerableEventsArray: [TriggerableEvent] {
        guard let event = event else { return [] }
        return Array(event as! Set<TriggerableEvent>)
    }

}

extension PitchBendMessage: ICDMidiMessage {
    var createdDate: Date {
        get {
            created ?? .distantPast
        }
        set {
            created = newValue
        }
    }

    public var triggerableEventsArray: [TriggerableEvent] {
        guard let event = event else { return [] }
        return Array(event as! Set<TriggerableEvent>)
    }
}

// MARK: TriggerableEvent extensions

extension TriggerableEvent {
    var parent: ICDMidiMessage {
        get {
            if let noteOn = noteOn {
                return noteOn
            }
            return noteOff!
        }
        set {
            if let newValue = newValue as? NoteOnMessage {
                noteOn = newValue
            } else if let newValue = newValue as? NoteOffMessage {
                noteOff = newValue
            } else if let newValue = newValue as? ControlChangeMessage {
                controlChange = newValue
            } else if let newValue = newValue as? ProgramChangeMessage {
                programChange = newValue
            } else if let newValue = newValue as? ChannelPressureMessage {
                channelPressure = newValue
            } else if let newValue = newValue as? PolyPressureMessage {
                polyPressure = newValue
            } else if let newValue = newValue as? PitchBendMessage {
                pitchBend = newValue
            } else {
                fatalError("Unknown parent")
            }
        }
    }
}

extension TriggerableEvent: CreatedAtDate {
    var createdDate: Date {
        get {
            created ?? .distantPast
        }
        set {
            created = newValue
        }
    }
}

// MARK: Key Stroke extensions

enum KeyStrokeAction: Int32 {
    case press
    case hold
    case release
}

extension KeyStroke {
    var unwrappedAction: KeyStrokeAction {
        get {
            return KeyStrokeAction(rawValue: self.action) ?? .press
        }
        set {
            self.action = Int32(newValue.rawValue)
        }
    }
}

extension KeyStroke {
    var unwrappedKeyCode: KeyCode {
        get {
            return KeyCode(rawValue: self.keyCode) ?? .return
        }
        set {
            self.keyCode = Int32(newValue.rawValue)
        }
    }
}
