//
//  ApplicationClosureView.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 05.02.2024.
//

import SwiftUI

struct ApplicationClosureView: View {
    @ObservedObject var closure: ApplicationClosure

    @Environment(\.managedObjectContext) var moc

    @State private var importing = false

    var body: some View {
        HStack {
            Text("App Closure").bold()
            Button("Select App") {
                importing = true
            }
            .fileImporter(
                isPresented: $importing,
                allowedContentTypes: [.application]
            ) { result in
                switch result {
                case .success(let file):
                    closure.unwrappedUrl = file
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .padding(.horizontal)
            if let appUrl = closure.unwrappedUrl {
                Image(nsImage: NSWorkspace.shared.icon(forFile: appUrl.path))
            }
            Text(closure.unwrappedUrl?.deletingPathExtension().lastPathComponent  ?? "Not specified")
                .padding(.horizontal)
        }
        .padding()
        .onChange(of: closure.unwrappedUrl) { _ in
            try? moc.save()
        }
    }
}

func getPreviewClosure() -> ApplicationClosure {
    let closure = ApplicationClosure(context: DataController.preview.container.viewContext)
    closure.url = "/System/Applications/App Store.app"
    return closure
}

#Preview {
    ApplicationClosureView(closure: getPreviewClosure())
}
