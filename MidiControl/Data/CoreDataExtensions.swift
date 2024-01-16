//
//  CDExtensions.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 16.01.2024.
//

import Foundation

extension NoteOnMessage {
    public var keyStrokesArray: [KeyStroke] {
        guard let keyStroke = keyStroke else { return [] }
        return Array(keyStroke as! Set<KeyStroke>)
    }
}

extension NoteOffMessage {
    public var keyStrokesArray: [KeyStroke] {
        guard let keyStroke = keyStroke else { return [] }
        return Array(keyStroke as! Set<KeyStroke>)
    }
}
