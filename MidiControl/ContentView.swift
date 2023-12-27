//
//  ContentView.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 23.12.2023.
//

import SwiftUI

func verifyAccessibility() -> Bool {
    return AXIsProcessTrusted();
}

func showAccessabilityPreferences() {
    NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!)
}

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

        var test = verifyAccessibility();

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

    @State private var showAccessabilityAlert = !verifyAccessibility()

    @State private var testInput = ""

    var body: some View {
        VStack {
            TextField(
                    "Test field",
                    text: $testInput
            )
            MidiList()
        }
        .padding()
        .alert("Enable accessibility", isPresented: $showAccessabilityAlert) {
            Button("OK") {
                showAccessabilityPreferences()
            }
            Button("Not Now") {
                // Do nothing...
            }
        } message: {
            Text("Please enable accessibility for MidiControl. Without it the application won't be able to simulate key strokes.")
        }
    }
}

#Preview {
    ContentView()
}
