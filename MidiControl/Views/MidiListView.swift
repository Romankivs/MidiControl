//
//  List.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 25.12.2023.
//

import SwiftUI
import Foundation

func randomString(length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<length).map{ _ in letters.randomElement()! })
}

struct KeyStroke : Identifiable, Hashable {
    var id = UUID()
    var keyCode: CGKeyCode
    var keyDown: Bool
    var midiStroke: MidiToStroke?
}

struct MidiToStroke : Identifiable, Hashable  {
    static func == (lhs: MidiToStroke, rhs: MidiToStroke) -> Bool {
        return lhs.id == rhs.id && lhs.midi.description == rhs.midi.description && lhs.stroke == rhs.stroke
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(midi.description)
        hasher.combine(stroke)
    }

    var id = UUID()
    var midi: IMidiMessage
    var stroke: [KeyStroke]
}

struct MidiList: View {
    @State private var selectedStroke: MidiToStroke?
    @State private var selectedKey: KeyStroke?

    @State var strokes: [MidiToStroke] = []

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Button(action: {
                        withAnimation {
                            let element = MidiToStroke(midi: MidiNoteOnMessage(channel: 5, note: 22, velocity: 126), stroke: [])
                            strokes.append(element)
                        }
                    }) {
                        Image(systemName: "plus")
                    }
                    Button(action: {
                        withAnimation {
                            if let selected = selectedStroke,
                               let index = strokes.firstIndex(of: selected) {
                                strokes.remove(at: index)
                                if strokes.count >= index, !strokes.isEmpty {
                                    selectedStroke = strokes[max(0, index - 1)]
                                }
                            }
                        }
                    }) {
                        Image(systemName: "minus")
                    }
                }
                List(strokes, id: \.self, selection: $selectedStroke) { stroke in
                    MidiMessageView(model: stroke.midi)
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
                            let stroke = KeyStroke(keyCode: 11, keyDown: false)
                            selectedStroke?.stroke.append(stroke)
                        }
                    }) {
                        Image(systemName: "plus")
                    }
                    Button(action: {
                        withAnimation {
                            guard let selected = selectedKey else { return }
                            guard let index = selectedStroke?.stroke.firstIndex(of: selected) else { return }
                            selectedStroke?.stroke.remove(at: index)
                            if let selectedStroke = selectedStroke,
                               selectedStroke.stroke.count >= index,
                               !selectedStroke.stroke.isEmpty {
                                selectedKey = selectedStroke.stroke[max(0, index - 1)]
                            }
                        }
                    }) {
                        Image(systemName: "minus")
                    }
                }
                if let selectedStroke = selectedStroke {
                    List(selectedStroke.stroke, id: \.self, selection: $selectedKey) { item in
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

