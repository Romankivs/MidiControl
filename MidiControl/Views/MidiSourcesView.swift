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
            Picker("Midi Input", selection: $midiSourcesManager.selectedSourceIndex) {
                ForEach((0..<midiSourcesManager.midiSources.count), id: \.self) {
                    Text(midiSourcesManager.midiSources[$0].name).tag($0)
                }
            }.onChange(of: midiSourcesManager.selectedSourceIndex) { _ in
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
