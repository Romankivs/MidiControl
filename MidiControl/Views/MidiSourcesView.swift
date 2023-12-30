//
//  MidiSourcesView.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 30.12.2023.
//

import SwiftUI

struct MidiSourcesView: View {
    @ObservedObject var midiSourcesManager: MidiSourcesManager

    var body: some View {
        VStack {
            Picker("Midi Input", selection: $midiSourcesManager.selectedSourceIndex) {
                ForEach((0..<midiSourcesManager.midiSources.count), id: \.self) {
                    Text(midiSourcesManager.midiSources[$0].name).tag($0)
                }
            }
            .frame(width: 300)
        }
    }
}


#Preview {
    MidiSourcesView(midiSourcesManager: MidiSourcesManager())
}
