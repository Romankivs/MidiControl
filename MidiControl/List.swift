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

    var keyCode: CGKeyCode
    var keyDown: Bool
    var stroke: MidiToStroke?
}

@Model
class MidiToStroke {
    init(name: String, stroke: [KeyStroke]) {
        self.name = name
        self.stroke = stroke
    }

    var name: String
    @Relationship(deleteRule: .cascade) var stroke: [KeyStroke]
}

struct MidiList: View {
    @State private var selectedStroke: MidiToStroke?

    @Environment(\.modelContext) private var context
    @Query var strokes: [MidiToStroke]

    var body: some View {
        HStack {
            VStack {
                Button("Add") {
                    let strokes = [KeyStroke(keyCode: 11, keyDown: false),
                                   KeyStroke(keyCode: 22, keyDown: true),
                                   KeyStroke(keyCode: 33, keyDown: false)]
                    let element = MidiToStroke(name: randomString(length: 5), stroke: strokes)
                    do {
                        context.insert(element)
                        try context.save()
                    }
                    catch {
                        print("Add: \(error)")
                    }
                }
                Button("Delete") {
                    if let selectedStroke = selectedStroke {
                        do {
                            context.delete(selectedStroke)
                            try context.save()
                        }
                        catch {
                            print("Delete: \(error)")
                        }
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

            if let selectedStroke = selectedStroke {
                List(selectedStroke.stroke, id: \.self) { item in
                    Text("\(item.keyCode)")
                }
            } else {
                Text("Select a midi combination")
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
        .padding()
    }
}

#Preview {
    MidiList()
        .modelContainer(previewContainer)
}

