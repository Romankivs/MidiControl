//
//  DataController.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 15.01.2024.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "MidiControl")

    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
