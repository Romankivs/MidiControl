//
//  MidiSourcesView.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 30.12.2023.
//

import SwiftUI

struct MidiSourcesView: View {
    @EnvironmentObject var midiSourcesManager: MidiSourcesManager
    @EnvironmentObject var midiReceiver: MidiReceiver

    var body: some View {
        VStack {
            Picker("Midi Input", selection: $midiSourcesManager.selectedSourceName) {
                ForEach(midiSourcesManager.midiSources, id: \.self) {
                    Text($0.name).tag($0.name)
                }
            }.onChange(of: midiSourcesManager.selectedSourceName) { _ in
                midiReceiver.updateSource()
            }
            .frame(width: 300)
        }
    }
}


#Preview {
    MidiSourcesView().environmentObject(MidiSourcesManager())
        .environmentObject(MidiReceiver(midiSourcesManager: MidiSourcesManager()))
}
