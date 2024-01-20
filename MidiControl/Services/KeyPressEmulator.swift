//
//  KeyPressEmulator.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 20.01.2024.
//

import CoreGraphics

class KeyPressEmulator {
    static func emulateKey(key: KeyStroke) {
        if key.unwrappedAction == .press || key.unwrappedAction == .hold {
            fireKeyAndAdditionalKeysIfNecessary(key: key, keyDown: true)
        }
        if key.unwrappedAction == .press || key.unwrappedAction == .release {
            fireKeyAndAdditionalKeysIfNecessary(key: key, keyDown: false)
        }
    }
    static private func fireKeyAndAdditionalKeysIfNecessary(key: KeyStroke, keyDown: Bool) {
        if !keyDown {
            fireEventForKey(keyCode: key.unwrappedKeyCode, keyDown: keyDown)
        }
        if (key.command) {
            fireEventForKey(keyCode: .cmd, keyDown: keyDown)
        }
        if (key.option) {
            fireEventForKey(keyCode: .option, keyDown: keyDown)
        }
        if (key.control) {
            fireEventForKey(keyCode: .control, keyDown: keyDown)
        }
        if (key.shift) {
            fireEventForKey(keyCode: .shift, keyDown: keyDown)
        }
        if keyDown {
            fireEventForKey(keyCode: key.unwrappedKeyCode, keyDown: keyDown)
        }
    }

    static private func fireEventForKey(keyCode: KeyCode, keyDown: Bool) {
        let eventSource = CGEventSource(stateID: .hidSystemState)
        let keyEvent = CGEvent(keyboardEventSource: eventSource, virtualKey: UInt16(keyCode.rawValue), keyDown: keyDown)

        // TODO: Add flags
        if keyCode != .cmd {
            keyEvent?.flags = .maskCommand
        }
        print("fired \(keyCode) \(keyDown)")
        keyEvent?.post(tap: .cghidEventTap)
    }
}
