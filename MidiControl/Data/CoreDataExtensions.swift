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
    var keyStrokesArray: [KeyStroke] { get }
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
    
    public var keyStrokesArray: [KeyStroke] {
        guard let keyStroke = keyStroke else { return [] }
        return Array(keyStroke as! Set<KeyStroke>)
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

    public var keyStrokesArray: [KeyStroke] {
        guard let keyStroke = keyStroke else { return [] }
        return Array(keyStroke as! Set<KeyStroke>)
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

    public var keyStrokesArray: [KeyStroke] {
        guard let keyStroke = keyStroke else { return [] }
        return Array(keyStroke as! Set<KeyStroke>)
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

    public var keyStrokesArray: [KeyStroke] {
        guard let keyStroke = keyStroke else { return [] }
        return Array(keyStroke as! Set<KeyStroke>)
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

    public var keyStrokesArray: [KeyStroke] {
        guard let keyStroke = keyStroke else { return [] }
        return Array(keyStroke as! Set<KeyStroke>)
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

    public var keyStrokesArray: [KeyStroke] {
        guard let keyStroke = keyStroke else { return [] }
        return Array(keyStroke as! Set<KeyStroke>)
    }
}

// MARK: Key Stroke extensions

extension KeyStroke {
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
            } else {
                fatalError("Unknown parent")
            }
        }
    }
}

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

extension KeyStroke: CreatedAtDate {
    var createdDate: Date {
        get {
            created ?? .distantPast
        }
        set {
            created = newValue
        }
    }
}
