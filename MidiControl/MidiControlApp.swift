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
            ContentView()
            .environment(\.managedObjectContext, appState.dataController.container.viewContext)
            .environmentObject(appState.midiSourcesManager)
            .environmentObject(appState.midiReceiver)
            .environmentObject(appState.midiEventsLogModel)
            .onAppear {
                appState.midiEventsLogModel.startLogTimer()
            }
            .onDisappear {
                appState.midiEventsLogModel.stopLogTimer()
            }
        }.commands {
            CommandGroup(after: .appInfo) {
                CheckForUpdatesView(updater: appState.updaterController.updater)
            }
        }
    }
}
