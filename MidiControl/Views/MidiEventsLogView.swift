//
//  MidiEventsLogView.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 06.01.2024.
//

import SwiftUI

struct MidiEventsLogView: View {
    @EnvironmentObject var midiEventsLogModel: MidiEventsLogModel

    var body: some View {
        List(midiEventsLogModel.logs) {
            Text($0.description)
        }
        .accessibilityLabel("Midi Logs List")
    }
}

#Preview {
    MidiEventsLogView()
        .environmentObject(MidiEventsLogModel(context: DataController.preview.container.viewContext))
}
