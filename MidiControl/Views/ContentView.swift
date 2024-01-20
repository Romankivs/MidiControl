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

struct KeyEventHandling: NSViewRepresentable {
    class KeyView: NSView {
        override var acceptsFirstResponder: Bool { true }
        override func keyDown(with event: NSEvent) {
            print(">> key \(event.charactersIgnoringModifiers ?? "")")
            print(">> key code \(event.keyCode)")
        }
    }

    func makeNSView(context: Context) -> NSView {
        let view = KeyView()
        DispatchQueue.main.async { // wait till next event cycle
            view.window?.makeFirstResponder(view)
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
    }
}

struct ContentView: View {
    // Create an instance of TextEntrySimulator to start the simulation
    let textEntrySimulator = TextEntrySimulator()

    var body: some View {
        VStack {
            MidiSourcesView()
            TabsMidiListsView()
            MidiEventsLogView()
        }
        .background(AccessibilityAlertView())
        .background(KeyEventHandling())
        .padding()
    }
}

#Preview {
    ContentView()
        .environmentObject(MidiSourcesManager())
        .environmentObject(MidiReceiver(midiSourcesManager: MidiSourcesManager()))
        .environmentObject(MidiEventsLogModel(context: DataController.preview.container.viewContext))
        .environment(\.managedObjectContext, DataController.preview.container.viewContext)
}
