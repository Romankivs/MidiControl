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

    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "order", ascending: true), NSSortDescriptor(key: "created", ascending: true)]) var messages: FetchedResults<T>

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Button(action: {
                        withAnimation {
                            var new = T(context: moc)
                            new.createdDate = .init()
                            new.userOrder = Int32.max
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
                List(selection: $selectedStroke) {
                    ForEach(messages, id: \.self) { stroke in
                        MidiMessageView(model: stroke)
                    }.onMove(perform: moveMessages)
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
                        Button {
                            guard let selectedMidi = selectedStroke else { return }
                            let appLaunch = ApplicationClosure(context: moc)
                            appLaunch.createdDate = .init()
                            appLaunch.parent = selectedMidi
                            try? moc.save()
                        } label: {
                            Label("New App Closure", systemImage: "xmark.circle")
                        }
                        Button {
                            guard let selectedMidi = selectedStroke else { return }
                            let delay = DelayEvent(context: moc)
                            delay.createdDate = .init()
                            delay.parent = selectedMidi
                            try? moc.save()
                        } label: {
                            Label("New Delay", systemImage: "timer")
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
                        (left.userOrder, left.createdDate) < (right.userOrder, right.createdDate)
                    }
                    List(selection: $selectedKey) {
                        ForEach(array, id: \.self) {
                            TriggerableEventView(model: $0)
                        }.onMove(perform: move)
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

    private func moveMessages( from source: IndexSet, to destination: Int)
    {
        // Make an array of items from fetched results
        var revisedItems: [ ICDMidiMessage ] = messages.map{ $0 }

        // change the order of the items in the array
        revisedItems.move(fromOffsets: source, toOffset: destination )

        // update the userOrder attribute in revisedItems to
        // persist the new order. This is done in reverse order
        // to minimize changes to the indices.
        for reverseIndex in stride( from: revisedItems.count - 1,
                                    through: 0,
                                    by: -1 )
        {
            revisedItems[ reverseIndex ].userOrder = Int32(reverseIndex)
        }

        try? moc.save()
    }

    private func move( from source: IndexSet, to destination: Int)
    {
        guard let selectedStroke = selectedStroke else { return }

        var revisedItems = selectedStroke.triggerableEventsArray.sorted { left, right in
            (left.userOrder, left.createdDate) < (right.userOrder, right.createdDate)
        }

        // change the order of the items in the array
        revisedItems.move(fromOffsets: source, toOffset: destination )

        // update the userOrder attribute in revisedItems to
        // persist the new order. This is done in reverse order
        // to minimize changes to the indices.
        for reverseIndex in stride( from: revisedItems.count - 1,
                                    through: 0,
                                    by: -1 )
        {
            revisedItems[ reverseIndex ].userOrder = Int32(reverseIndex)
        }

        try? moc.save()

        self.selectedStroke = nil
        self.selectedStroke = selectedStroke
    }
}

#Preview {
    GenericMidiListView<NoteOnMessage>()
}
