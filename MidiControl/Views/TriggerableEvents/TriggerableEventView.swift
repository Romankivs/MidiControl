//
//  TriggerableEventView.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 05.02.2024.
//

import SwiftUI

struct TriggerableEventView: View {
    var model: TriggerableEvent

    var body: some View {
        switch model {
        case let model as KeyStroke:
            KeyStrokeView(stroke: model)
        case let model as ApplicationLaunch:
            ApplicationLaunchView(launch: model)
        case let model as ApplicationClosure:
            ApplicationClosureView(closure: model)
        case let model as DelayEvent:
            DelayEventView(delay: model)
        default: Text("Unknown event")
        }
    }
}
