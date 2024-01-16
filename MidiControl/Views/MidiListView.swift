//
//  List.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 25.12.2023.
//

import SwiftUI
import Foundation

struct MidiList: View {
    @State private var selectedStroke: NoteOnMessage?
    @State private var selectedKey: KeyStroke?

    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var noteOnMessages: FetchedResults<NoteOnMessage>
    @FetchRequest(sortDescriptors: []) var noteOffMessages: FetchedResults<NoteOffMessage>

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Button(action: {
                        withAnimation {
                            let noteOn = NoteOnMessage(context: moc)
                            noteOn.id = UUID()

                            try? moc.save()
                        }
                    }) {
                        Image(systemName: "plus")
                    }
                    Button(action: {
                        withAnimation {
                            if let selected = selectedStroke {
                                moc.delete(selected)
                                
                                try? moc.save()
                            }
                        }
                    }) {
                        Image(systemName: "minus")
                    }
                }
                List(noteOnMessages, id: \.self, selection: $selectedStroke) { stroke in
                    MidiMessageView(model: stroke)
                }
            }

            VStack {
                Image(systemName: "arrow.right")
                    .resizable()
                    .frame(width: 20, height: 15)
                    .foregroundColor(.gray)
            }

            VStack(alignment: .leading) {
                HStack {
                    Button(action: {
                        withAnimation {
                            guard let selectedMidi = selectedStroke else { return }

                            let stroke = KeyStroke(context: moc)
                            stroke.id = UUID()
                            stroke.keyCode = 33
                            stroke.noteOn = selectedMidi

                            try? moc.save()
                        }
                    }) {
                        Image(systemName: "plus")
                    }
                    Button(action: {
                        withAnimation {
                            guard let selected = selectedKey else { return }

                            moc.delete(selected)

                            try? moc.save()
                        }
                    }) {
                        Image(systemName: "minus")
                    }
                }
                if let selectedStroke = selectedStroke {
                    List(selectedStroke.keyStrokesArray, id: \.self, selection: $selectedKey) { item in
                        Text("\(item.keyCode)")
                    }
                } else {
                    List {
                        VStack(alignment: .center) {
                            Text("Select a midi combination")
                                .foregroundColor(.secondary)
                                .padding()
                        }
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    MidiList()
}

