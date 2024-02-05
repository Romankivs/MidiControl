//
//  GenericMidiListView.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 17.01.2024.
//

import SwiftUI

struct GenericMidiListView<T: NSManagedObject & ICDMidiMessage>: View {
    @State private var selectedStroke: T?
    @State private var selectedKey: TriggerableEvent?

    @Environment(\.managedObjectContext) var moc

    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "created", ascending: true)]) var messages: FetchedResults<T>

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Button(action: {
                        withAnimation {
                            var new = T(context: moc)
                            new.createdDate = .init()
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
                List(messages, id: \.self, selection: $selectedStroke) { stroke in
                    MidiMessageView(model: stroke)
                }.clipShape(.rect(cornerRadius: 3))
            }

            VStack {
                Image(systemName: "arrow.right")
                    .resizable()
                    .frame(width: 20, height: 15)
                    .foregroundColor(.gray)
            }

            VStack(alignment: .leading) {
                HStack {
                    Menu {
                        Button {
                            withAnimation {
                                guard let selectedMidi = selectedStroke else { return }

                                let stroke = KeyStroke(context: moc)
                                stroke.createdDate = .init()
                                stroke.keyCode = 33
                                stroke.parent = selectedMidi

                                try? moc.save()
                            }
                        } label: {
                            Label("New Key Stroke", systemImage: "keyboard")
                        }
                        Button {
                            guard let selectedMidi = selectedStroke else { return }

                            let appLaunch = ApplicationLaunch(context: moc)
                            appLaunch.createdDate = .init()
                            appLaunch.parent = selectedMidi

                            try? moc.save()
                        } label: {
                            Label("New App Launch", systemImage: "apple.terminal")
                        }
                    } label: {
                        Label("", systemImage: "plus")
                    }.fixedSize().labelsHidden()
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
                    let array = selectedStroke.triggerableEventsArray.sorted { left, right in
                        left.createdDate < right.createdDate
                    }
                    List(array, id: \.self, selection: $selectedKey) { item in
                        if let item = item as? KeyStroke {
                            KeyStrokeView(stroke: item)
                        } else if let item = item as? ApplicationLaunch {
                            ApplicationLaunchView(launch: item)
                        } else {
                            Text("Something else")
                        }
                    }
                    .clipShape(.rect(cornerRadius: 3))
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
    GenericMidiListView<NoteOnMessage>()
}
