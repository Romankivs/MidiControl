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
    var id = UUID()
    var name: String
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
                        let element = MidiToStroke(name: "fff", stroke: [])
                        strokes.append(element)
                    }) {
                        Image(systemName: "plus")
                    }
                    Button(action: {
                        if let selected = selectedStroke,
                           let index = strokes.firstIndex(of: selected) {
                            strokes.remove(at: index)
                            if !strokes.isEmpty {
                                selectedStroke = strokes[0]
                            }
                        }
                    }) {
                        Image(systemName: "minus")
                    }
                }
                List(strokes, id: \.self, selection: $selectedStroke) { stroke in
                    Text(stroke.name)
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
                        let stroke = KeyStroke(keyCode: 11, keyDown: false)
                        selectedStroke?.stroke.append(stroke)
                    }) {
                        Image(systemName: "plus")
                    }
                    Button(action: {
                        guard let selected = selectedKey else { return }
                        guard let index = selectedStroke?.stroke.firstIndex(of: selected) else { return }
                        selectedStroke?.stroke.remove(at: index)
                        if let selectedStroke = selectedStroke, !selectedStroke.stroke.isEmpty {
                            selectedKey = selectedStroke.stroke[0]
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

