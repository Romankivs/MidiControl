//
//  AppState.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 04.01.2024.
//

import Foundation

class AppState {
    init(midiSourcesManager: MidiSourcesManager = .init()) {
        self.midiSourcesManager = midiSourcesManager
        self.midiReceiver = MidiReceiver(midiSourcesManager: midiSourcesManager)
        self.midiEventsLogModel = MidiEventsLogModel(midiAdapter: midiReceiver.midiAdapter)
    }
    
    var midiSourcesManager: MidiSourcesManager
    var midiReceiver: MidiReceiver
    var midiEventsLogModel: MidiEventsLogModel
}