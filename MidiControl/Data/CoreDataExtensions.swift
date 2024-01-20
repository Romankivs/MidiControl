//
//  CDExtensions.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 16.01.2024.
//

import Foundation

// MARK: MIDI Messages extensions

protocol ICDMidiMessage {
    var keyStrokesArray: [KeyStroke] { get }
}

extension NoteOnMessage: ICDMidiMessage {
    public var keyStrokesArray: [KeyStroke] {
        guard let keyStroke = keyStroke else { return [] }
        return Array(keyStroke as! Set<KeyStroke>)
    }
}

extension NoteOffMessage: ICDMidiMessage {
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
            } else {
                noteOff = newValue as? NoteOffMessage
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
