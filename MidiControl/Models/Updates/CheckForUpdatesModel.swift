//
//  CheckForUpdatesModel.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 30.01.2024.
//

import Sparkle

// This view model class publishes when new updates can be checked by the user
class CheckForUpdatesModel: ObservableObject {
    @Published var canCheckForUpdates = false

    init(updater: SPUUpdater) {
        updater.publisher(for: \.canCheckForUpdates)
            .assign(to: &$canCheckForUpdates)
    }
}
