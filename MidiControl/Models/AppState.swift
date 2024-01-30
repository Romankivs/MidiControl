//
//  AppState.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 04.01.2024.
//

import Foundation
import Sparkle

class AppState {
    init(dataController: DataController = .init(), midiSourcesManager: MidiSourcesManager = .init()) {
        self.dataController = dataController
        self.midiSourcesManager = midiSourcesManager
        self.midiReceiver = MidiReceiver(midiSourcesManager: midiSourcesManager)
        self.midiEventsLogModel = MidiEventsLogModel(midiAdapter: midiReceiver.midiAdapter, context: dataController.container.viewContext)
        self.updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
    }
    
    var dataController: DataController
    var midiSourcesManager: MidiSourcesManager
    var midiReceiver: MidiReceiver
    var midiEventsLogModel: MidiEventsLogModel

    var updaterController: SPUStandardUpdaterController
}
