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

class KeyStroke : Hashable {
    static func == (lhs: KeyStroke, rhs: KeyStroke) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    init(keyCode: CGKeyCode, keyDown: Bool) {
        self.keyCode = keyCode
        self.keyDown = keyDown
    }

    var id = UUID()
    var keyCode: CGKeyCode
    var keyDown: Bool
    var midiStroke: MidiToStroke?
}

class MidiToStroke : Hashable  {
    static func == (lhs: MidiToStroke, rhs: MidiToStroke) -> Bool {
        return lhs.id == rhs.id;
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    init(name: String, stroke: [KeyStroke]) {
        self.name = name
        self.stroke = stroke
    }

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
            VStack {
                Button("Add") {
                    let element = MidiToStroke(name: "fff", stroke: [])
                    strokes.append(element)
                }
                Button("Delete") {
                    if let selected = selectedStroke,
                       let index = strokes.firstIndex(of: selected) {
                            strokes.remove(at: index)
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

            VStack {
                Button("Add") {
                    guard let selectedStroke = selectedStroke else { return }
                    let stroke = KeyStroke(keyCode: 11, keyDown: false)
                    selectedStroke.stroke.append(stroke)
                }
                Button("Delete") {
                    guard let selectedStroke = selectedStroke else { return }
                    guard let selected = selectedKey else { return }
                    guard let index = selectedStroke.stroke.firstIndex(of: selected) else { return }
                    selectedStroke.stroke.remove(at: index)
                    if !selectedStroke.stroke.isEmpty {
                        selectedKey = selectedStroke.stroke[0]
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

