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
    private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView(midiSourcesManager: appState.midiSourcesManager,
                        midiReceiver: appState.midiReceiver,
                        midiEventsLogModel: appState.midiEventsLogModel)
            .onAppear {
                appState.midiEventsLogModel.startLogTimer()
            }
            .onDisappear {
                appState.midiEventsLogModel.stopLogTimer()
            }
        }
    }
}
