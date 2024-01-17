//
//  CDExtensions.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 16.01.2024.
//

import Foundation

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
