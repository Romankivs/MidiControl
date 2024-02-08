//
//  DelayEventView.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 08.02.2024.
//

import SwiftUI

struct DelayEventView: View {
    @ObservedObject var delay: DelayEvent

    @Environment(\.managedObjectContext) var moc

    var body: some View {
        HStack {
            Text("Delay").bold().padding()
            TextFieldUInt32(value: $delay.amountMilliseconds,
                            name: "Amount In Milliseconds",
                            emptyText: "Enter delay amount",
                            maximum: 4294967)
        }
        .onChange(of: delay.amountMilliseconds) { _ in
            try? moc.save()
        }
    }
}

func getPreviewDelayEvent() -> DelayEvent {
    let delay = DelayEvent(context: DataController.preview.container.viewContext)
    delay.amountMilliseconds = 300000
    return delay
}

#Preview {
    DelayEventView(delay: getPreviewDelayEvent())
}
