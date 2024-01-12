//
//  MidiMessageViews.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 12.01.2024.
//

import SwiftUI

struct MidiMessageView: View {
    @Binding var midiMessage: MidiMessage

    var body: some View {
        HStack {
            switch midiMessage {
            case .noteOn(let channel, let note, let velocity):
                Text("Note on")
//            case .noteOff(let channel, let note, let velocity):
//                <#code#>
//            case .polyPressure(let channel, let noteNumber, let data):
//                <#code#>
//            case .controlChange(let channel, let index, let data):
//                <#code#>
//            case .programChange(let channe, let program):
//                <#code#>
//            case .channelPressure(let channel, let data):
//                <#code#>
//            case .pitchBend(let channel, let lsbData, let msbData):
//                <#code#>
            default: Text("Unknown message")
            }
        }
    }
}

#Preview {
    MidiMessageView(midiMessage: .constant(.noteOn(channel: 6, note: 55, velocity: 127)))
}
