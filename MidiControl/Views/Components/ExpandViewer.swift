//
//  ExpandViewer.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 31.01.2024.
//

import SwiftUI

struct ExpandViewer<Content: View> : View {
    @State private var isExpanded = false
    @ViewBuilder let expandableView : Content

    var body: some View {
        VStack {
            Button(action: {
                withAnimation(.easeIn(duration: 0.25)) {
                    self.isExpanded.toggle()
                }

            }){
                Text(self.isExpanded ? "Hide Logs" : "View Midi Messages Logs")
                    .frame(maxWidth: .infinity, minHeight: 40, alignment: .center)
                    .clipShape(.rect(cornerRadius: 5))
            }

            if self.isExpanded {
                 self.expandableView
            }
        }
    }
}
