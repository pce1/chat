//
//  TranscriptStore.swift
//  VoiceStenogram
//
//  Manages transcript persistence and CRUD operations
//

import Foundation

class TranscriptStore: ObservableObject {
    @Published var transcripts: [Transcript] = []

    private let saveKey = "SavedTranscripts"

    init() {
        loadTranscripts()
    }

    func addTranscript(_ transcript: Transcript) {
        transcripts.insert(transcript, at: 0)
        saveTranscripts()
    }

    func updateTranscript(_ transcript: Transcript) {
        if let index = transcripts.firstIndex(where: { $0.id == transcript.id }) {
            transcripts[index] = transcript
            saveTranscripts()
        }
    }

    func deleteTranscript(_ transcript: Transcript) {
        transcripts.removeAll { $0.id == transcript.id }
        saveTranscripts()
    }

    func deleteTranscripts(at offsets: IndexSet) {
        transcripts.remove(atOffsets: offsets)
        saveTranscripts()
    }

    private func saveTranscripts() {
        if let encoded = try? JSONEncoder().encode(transcripts) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }

    private func loadTranscripts() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Transcript].self, from: data) {
            transcripts = decoded
        }
    }
}
