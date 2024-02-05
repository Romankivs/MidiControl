//
//  ApplicationLaunchView.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 04.02.2024.
//

import SwiftUI

struct ApplicationLaunchView: View {
    @ObservedObject var launch: ApplicationLaunch

    @Environment(\.managedObjectContext) var moc

    @State private var importing = false

    var body: some View {
        HStack {
            Text("App Launch").bold()
            Button("Select App") {
                importing = true
            }
            .fileImporter(
                isPresented: $importing,
                allowedContentTypes: [.application]
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
            Text(launch.unwrappedUrl?.deletingPathExtension().lastPathComponent  ?? "Not specified")
                .padding(.horizontal)
            ToggleCheckBox(text: "Activates", value: $launch.activates)
                .padding(.horizontal)
            ToggleCheckBox(text: "Hide Others", value: $launch.hidesOthers)
                .padding(.horizontal)
            ToggleCheckBox(text: "New Instance", value: $launch.newInstance)
                .padding(.horizontal)
        }
        .padding()
        .onChange(of: launch.unwrappedUrl) { _ in
            try? moc.save()
        }
    }
}

func getPreviewLaunch() -> ApplicationLaunch {
    let launch = ApplicationLaunch(context: DataController.preview.container.viewContext)
    launch.url = "/System/Applications/App Store.app"
    return launch
}

#Preview {
    ApplicationLaunchView(launch: getPreviewLaunch())
}
