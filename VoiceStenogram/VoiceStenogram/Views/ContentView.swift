//
//  ContentView.swift
//  VoiceStenogram
//
//  Main tab-based navigation view
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            RecordingView()
                .tabItem {
                    Label("Record", systemImage: "mic.circle.fill")
                }

            TranscriptListView()
                .tabItem {
                    Label("Transcripts", systemImage: "list.bullet.rectangle")
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(TranscriptStore())
}
