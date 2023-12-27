//
//  PreviewContainer.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 25.12.2023.
//

import SwiftUI
import SwiftData

@MainActor
let previewContainer: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: MidiToStroke.self, configurations: config)

            for i in 1...9 {
                let strokes = [KeyStroke(keyCode: 11, keyDown: false),
                               KeyStroke(keyCode: 22, keyDown: true),
                               KeyStroke(keyCode: 33, keyDown: false)]
                let element = MidiToStroke(name: "Example Midi \(i)", stroke: strokes)
                container.mainContext.insert(element)
            }

            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
}()
