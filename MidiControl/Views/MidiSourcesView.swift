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
        VStack(alignment: .leading) {
            ForEach(midiSourcesManager.midiSources) { source in
                Toggle(isOn: Binding(get: { midiSourcesManager.selectedSourcesNames.contains(source.name)
                }, set: {
                    if $0 {
                        midiSourcesManager.selectedSourcesNames.insert(source.name)
                    } else {
                        midiSourcesManager.selectedSourcesNames.remove(source.name)
                    }
                })) {
                    Text(source.name)
                }
            }
        }
        .onChange(of: midiSourcesManager.selectedSourcesNames) { _ in
            midiReceiver.updateSource()
        }
    }
}


#Preview {
    MidiSourcesView().environmentObject(MidiSourcesManager())
        .environmentObject(MidiReceiver(midiSourcesManager: MidiSourcesManager()))
}
