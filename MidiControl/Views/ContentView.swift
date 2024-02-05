//
//  ContentView.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 23.12.2023.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        VStack {
            MidiSourcesView()
            TabsMidiListsView()
            ExpandViewer {
                MidiEventsLogView()
            }
        }
        .background(AccessibilityAlertView())
        .padding()
        .frame(minWidth: 1100, idealWidth: 1920, minHeight: 500, idealHeight: 1080)
    }
}

#Preview {
    ContentView()
        .environmentObject(MidiSourcesManager())
        .environmentObject(MidiReceiver(midiSourcesManager: MidiSourcesManager()))
        .environmentObject(MidiEventsLogModel(context: DataController.preview.container.viewContext))
        .environment(\.managedObjectContext, DataController.preview.container.viewContext)
}
