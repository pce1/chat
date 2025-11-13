//
//  VoiceStenogramApp.swift
//  VoiceStenogram
//
//  Main app entry point
//

import SwiftUI

@main
struct VoiceStenogramApp: App {
    @StateObject private var transcriptStore = TranscriptStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(transcriptStore)
        }
    }
}
