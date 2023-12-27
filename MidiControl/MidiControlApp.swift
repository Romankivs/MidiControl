//
//  MidiControlApp.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 23.12.2023.
//

import SwiftUI
import SwiftData

@main
struct MidiControlApp: App {
    var container: ModelContainer
    
    init() {
        do {
            let storeURL = URL.documentsDirectory.appending(path: "midicontroldb.sqlite")
            let config = ModelConfiguration(url: storeURL)
            container = try ModelContainer(for: MidiToStroke.self, configurations: config)
        } catch {
            fatalError("Failed to configure SwiftData container.")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
