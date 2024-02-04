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
            Button("Select App") {
                importing = true
            }
            .fileImporter(
                isPresented: $importing,
                allowedContentTypes: [.application]
            ) { result in
                switch result {
                case .success(let file):
                    launch.url = file.relativePath
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            VStack {
                HStack {
                    if let appUrl = launch.url {
                        Image(nsImage: NSWorkspace.shared.icon(forFile: appUrl))
                    }
                    Text(launch.url ?? "Not specified")
                }
            }
        }.padding(.horizontal)
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
