//
//  ScriptLaunchView.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 10.02.2024.
//

import SwiftUI

struct ScriptLaunchView: View {
    @ObservedObject var launch: ScriptLaunch

    @Environment(\.managedObjectContext) var moc

    @State private var importing = false

    var body: some View {
        HStack {
            Text("Script Launch").bold()
            Button("Select Script File") {
                importing = true
            }
            .fileImporter(
                isPresented: $importing,
                allowedContentTypes: [.script]
            ) { result in
                switch result {
                case .success(let file):
                    launch.unwrappedUrl = file
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .padding(.horizontal)
            if let appUrl = launch.unwrappedUrl {
                Image(nsImage: NSWorkspace.shared.icon(forFile: appUrl.path))
            }
            Text(launch.unwrappedUrl?.lastPathComponent  ?? "Not specified")
                .padding(.horizontal)
        }
        .padding()
        .onChange(of: launch.unwrappedUrl) { _ in
            try? moc.save()
        }
    }
}
