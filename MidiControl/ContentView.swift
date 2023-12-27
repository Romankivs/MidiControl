//
//  ContentView.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 23.12.2023.
//

import SwiftUI

class TextEntrySimulator {
    var timer: Timer?

    init() {
        // Initialize the timer to fire every second
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(enterText), userInfo: nil, repeats: true)
    }

    @objc func enterText() {
        typeText("hello")
    }

    func typeText(_ text: String) {
        let eventSource = CGEventSource(stateID: .hidSystemState)

        // Simulate typing characters
        for _ in text {
            let keyCode = UInt16(2) // letter d
            let keyDownEvent = CGEvent(keyboardEventSource: eventSource, virtualKey: keyCode, keyDown: true)
            let keyUpEvent = CGEvent(keyboardEventSource: eventSource, virtualKey: keyCode, keyDown: false)

            keyDownEvent?.post(tap: .cghidEventTap)
            keyUpEvent?.post(tap: .cghidEventTap)

            // Add a small delay between key events to simulate typing speed
            usleep(10000) // 10 milliseconds
        }
    }

    deinit {
        // Invalidate the timer when the object is deallocated
        timer?.invalidate()
    }
}


struct ContentView: View {
    // Create an instance of TextEntrySimulator to start the simulation
    let textEntrySimulator = TextEntrySimulator()

    @State private var testInput = ""

    var body: some View {
        VStack {
            AccessibilityAlertView()
            TextField(
                    "Test field",
                    text: $testInput
            )
            MidiList()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
