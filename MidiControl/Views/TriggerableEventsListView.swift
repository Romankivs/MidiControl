//
//  TriggerableEventsListView.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 09.02.2024.
//

import SwiftUI

struct TriggerableEventsListView: View {
    let parent: NSManagedObject

    @Binding var selectedKey: TriggerableEvent?

    @Environment(\.managedObjectContext) var moc

    @FetchRequest var messages: FetchedResults<TriggerableEvent>

    init(parent: NSManagedObject, selectedKey: Binding<TriggerableEvent?>) {
        self.parent = parent
        self._selectedKey = selectedKey

        _messages = FetchRequest(
            entity: TriggerableEvent.entity(),
            sortDescriptors: [
                NSSortDescriptor(key: "userOrder", ascending: true),
                NSSortDescriptor(key: "created", ascending: true)
            ],
            predicate: NSPredicate(format: "noteOn == %@", parent)
        )
    }

    var body: some View {
        List(selection: $selectedKey) {
            ForEach(messages, id: \.self) {
                TriggerableEventView(model: $0)
            }//.onMove(perform: move)
        }
        .clipShape(.rect(cornerRadius: 3))
    }
}
