//
//  TabsView.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 17.01.2024.
//

import SwiftUI

struct TabsMidiListsView: View {
    var body: some View {
        TabView {
            GenericMidiListView<NoteOnMessage>().tabItem { Text("Note On") }
            GenericMidiListView<NoteOffMessage>().tabItem { Text("Note Off") }
            GenericMidiListView<ControlChangeMessage>().tabItem { Text("Control Change") }
            GenericMidiListView<ProgramChangeMessage>().tabItem { Text("Program Change") }
            GenericMidiListView<ChannelPressureMessage>().tabItem { Text("Channel Pressure") }
            GenericMidiListView<PolyPressureMessage>().tabItem { Text("Poly Pressure") }
            GenericMidiListView<PitchBendMessage>().tabItem { Text("Pitch Bend") }
        }
    }
}

#Preview {
    TabsMidiListsView()
}
