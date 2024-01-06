//
//  MidiEventsLogView.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 06.01.2024.
//

import SwiftUI

struct MidiEventsLogView: View {
    @ObservedObject var midiEventsLogModel: MidiEventsLogModel

    var body: some View {
        List(midiEventsLogModel.logs) {
            Text($0.description)
        }
    }
}

#Preview {
    MidiEventsLogView(midiEventsLogModel: MidiEventsLogModel())
}
