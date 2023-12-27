//
//  List.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 25.12.2023.
//

import SwiftUI
import SwiftData
import Foundation

func randomString(length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<length).map{ _ in letters.randomElement()! })
}

@Model
class KeyStroke {
    init(keyCode: CGKeyCode, keyDown: Bool) {
        self.keyCode = keyCode
        self.keyDown = keyDown
    }

    var creationDate: Date = Date.now
    var keyCode: CGKeyCode
    var keyDown: Bool
    var midiStroke: MidiToStroke?
}

@Model
class MidiToStroke {
    init(name: String, stroke: [KeyStroke]) {
        self.name = name
        self.stroke = stroke
    }

    var creationDate: Date = Date.now
    var name: String
    @Relationship(deleteRule: .cascade, inverse: \KeyStroke.midiStroke) var stroke: [KeyStroke]
}

struct MidiList: View {
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Context save error: \(error.localizedDescription)")
        }
    }

    @State private var selectedStroke: MidiToStroke?
    @State private var selectedKey: KeyStroke?

    @Environment(\.modelContext) private var context
    @Query var strokes: [MidiToStroke]

    var body: some View {
        HStack {
            VStack {
                Button("Add") {
                    let element = MidiToStroke(name: "fff", stroke: [])
                    context.insert(element)
                    saveContext()
                }
                Button("Delete") {
                    if let selected = selectedStroke {
                        context.delete(selected)
                        saveContext()
                        if !strokes.isEmpty {
                            selectedStroke = strokes[0]
                        }
                    }
                }
                List(strokes, id: \.self, selection: $selectedStroke) { stroke in
                    Text(stroke.name)
                }.onChange(of: selectedStroke) {
                    print(selectedStroke?.stroke ?? "Empty")
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
                    saveContext()
                }
                Button("Delete") {
                    if let selected = selectedKey {
                        context.delete(selected)
                        saveContext()
                        if let selectedStroke = selectedStroke, !selectedStroke.stroke.isEmpty {
                            selectedKey = selectedStroke.stroke[0]
                        }
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
        .modelContainer(previewContainer)
}

