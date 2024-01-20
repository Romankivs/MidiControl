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

    static var preview: DataController = {
        let result = DataController(inMemory: true)
        return result
    }()

    init(inMemory: Bool = false) {
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
