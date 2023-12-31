//
//  AccessibilityAlertView.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 27.12.2023.
//

import SwiftUI

func verifyAccessibility() -> Bool {
    return AXIsProcessTrusted();
}

func showAccessabilityPreferences() {
    NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!)
}

struct AccessibilityAlertView: View {
    @State private var showAccessabilityAlert = !verifyAccessibility()

    var body: some View {
        VStack {
            // Empty
        }
        .alert(isPresented: $showAccessabilityAlert) {
            Alert(title: Text("Enable accessibility"),
                  message: Text("Please enable accessibility for MidiControl. Without it the application won't be able to simulate key strokes."),
                  primaryButton: .default(
                    Text("Ok"),
                    action: showAccessabilityPreferences
                  ),
                  secondaryButton: .default(
                    Text("Not Now")
                  )
            )
        }
    }
}

#Preview {
    AccessibilityAlertView()
}
