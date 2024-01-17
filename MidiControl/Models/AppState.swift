//
//  AppState.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 04.01.2024.
//

import Foundation

class AppState {
    init(dataController: DataController = .init(), midiSourcesManager: MidiSourcesManager = .init()) {
        self.dataController = dataController
        self.midiSourcesManager = midiSourcesManager
        self.midiReceiver = MidiReceiver(midiSourcesManager: midiSourcesManager)
        self.midiEventsLogModel = MidiEventsLogModel(midiAdapter: midiReceiver.midiAdapter, context: dataController.container.viewContext)
    }
    
    var dataController: DataController
    var midiSourcesManager: MidiSourcesManager
    var midiReceiver: MidiReceiver
    var midiEventsLogModel: MidiEventsLogModel
}
