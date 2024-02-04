//
//  MidiSourcesView.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 30.12.2023.
//

import SwiftUI

extension Image {
    init(contentsOfFile: String) {
        let nsImage = NSImage(contentsOf: URL(fileURLWithPath: contentsOfFile))
        // You could force unwrap here if you are 100% sure the image exists
        // but it is better to handle it gracefully
        if let image = nsImage {
            self.init(nsImage: image)
        } else {
            self.init(systemName: "xmark.octagon")
        }
    }
}

struct MidiSourcesView: View {
    @EnvironmentObject var midiSourcesManager: MidiSourcesManager
    @EnvironmentObject var midiReceiver: MidiReceiver

    var body: some View {
        HStack(alignment: .center) {
            ForEach(midiSourcesManager.midiSources) { source in
                Toggle(isOn: Binding(get: { midiSourcesManager.selectedSourcesNames.contains(source.name)
                }, set: {
                    if $0 {
                        midiSourcesManager.selectedSourcesNames.insert(source.name)
                    } else {
                        midiSourcesManager.selectedSourcesNames.remove(source.name)
                    }
                })) {
                    HStack {
                        if !source.image.isEmpty {
                            Image(contentsOfFile: source.image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 32)
                        }
                        Text(source.name)
                    }
                    .padding(.leading, 5.0)
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
