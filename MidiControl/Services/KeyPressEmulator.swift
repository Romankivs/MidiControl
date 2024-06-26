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
        if key.unwrappedAction == .press {
            usleep(100000) // simulate a 0.1 millisecond hold
        }
        if key.unwrappedAction == .press || key.unwrappedAction == .release {
            fireKeyAndAdditionalKeysIfNecessary(key: key, keyDown: false)
        }
    }

    static private func fireKeyAndAdditionalKeysIfNecessary(key: KeyStroke, keyDown: Bool) {
        if (key.command) {
            fireEventForKey(keyCode: .cmd, keyDown: keyDown,
                            command: false, option: key.option,
                            control: key.control, shift: key.shift)
        }
        if (key.option) {
            fireEventForKey(keyCode: .option, keyDown: keyDown,
                            command: key.command, option: false,
                            control: key.control, shift: key.shift)
        }
        if (key.control) {
            fireEventForKey(keyCode: .control, keyDown: keyDown,
                            command: key.command, option: key.option,
                            control: false, shift: key.shift)
        }
        if (key.shift) {
            fireEventForKey(keyCode: .shift, keyDown: keyDown,
                            command: key.command, option: key.option,
                            control: key.control, shift: false)
        }
        fireEventForKey(keyCode: key.unwrappedKeyCode, keyDown: keyDown,
                        command: key.command, option: key.option,
                        control: key.control, shift: key.shift)
    }

    static private func fireEventForKey(keyCode: KeyCode, keyDown: Bool,
                                        command: Bool = false, option: Bool = false,
                                        control: Bool = false, shift: Bool = false) {
        let eventSource = CGEventSource(stateID: .hidSystemState)
        let keyEvent = CGEvent(keyboardEventSource: eventSource, virtualKey: UInt16(keyCode.rawValue), keyDown: keyDown)

        keyEvent?.flags = getEventFlags(command: command, option: option, control: control, shift: shift)

        keyEvent?.post(tap: .cghidEventTap)

        print("Triggered key event: \(keyCode) down: \(keyDown) command: \(command)",
              "option: \(option) control: \(control) shift: \(shift)")
    }

    static private func getEventFlags(command: Bool, option: Bool, control: Bool, shift: Bool) -> CGEventFlags {
        var flags: CGEventFlags = []
        if command {
            flags.insert(.maskCommand)
        }
        if option {
            flags.insert(.maskAlternate)
        }
        if control {
            flags.insert(.maskControl)
        }
        if shift {
            flags.insert(.maskShift)
        }
        return flags
    }

    static func emulateMouseKey(type: MouseEventType, posX: Double, posY: Double, button: Int32) {
        let eventSource = CGEventSource(stateID: .hidSystemState)
        let mouseEvent = CGEvent(mouseEventSource: eventSource, mouseType: type.toCGEventType(),
                                 mouseCursorPosition: CGPoint(x: posX, y: posY), mouseButton: CGMouseButton(rawValue: UInt32(button)) ?? .left)

        mouseEvent?.post(tap: .cghidEventTap)

        print("Triggered mouse event: \(type) position X: \(posX) position Y: \(posY) button: \(button)")

    }
}
