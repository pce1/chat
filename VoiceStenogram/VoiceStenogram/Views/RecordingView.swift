//
//  RecordingView.swift
//  VoiceStenogram
//
//  Main view for recording and transcribing voice
//

import SwiftUI
import Speech

struct RecordingView: View {
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @EnvironmentObject var transcriptStore: TranscriptStore
    @State private var showingSaveSheet = false
    @State private var savedTranscriptId: UUID?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Authorization status
                if speechRecognizer.authorizationStatus != .authorized {
                    authorizationView
                } else {
                    // Recording interface
                    ScrollView {
                        VStack(spacing: 20) {
                            // Recording status
                            recordingStatusView

                            // Transcript display
                            transcriptTextView

                            // Error message
                            if let error = speechRecognizer.errorMessage {
                                Text(error)
                                    .foregroundColor(.red)
                                    .font(.caption)
                                    .padding()
                                    .background(Color.red.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                        .padding()
                    }

                    Spacer()

                    // Control buttons
                    controlButtons
                }
            }
            .navigationTitle("Voice Stenogram")
            .sheet(isPresented: $showingSaveSheet) {
                if let transcriptId = savedTranscriptId,
                   let transcript = transcriptStore.transcripts.first(where: { $0.id == transcriptId }) {
                    TranscriptDetailView(transcript: transcript)
                }
            }
        }
    }

    // MARK: - Subviews

    private var authorizationView: some View {
        VStack(spacing: 20) {
            Image(systemName: "mic.slash.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.gray)

            Text("Speech Recognition Permission Required")
                .font(.headline)

            Text("Please grant permission to use speech recognition")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button("Grant Permission") {
                speechRecognizer.requestAuthorization()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }

    private var recordingStatusView: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(speechRecognizer.isRecording ? Color.red.opacity(0.2) : Color.gray.opacity(0.2))
                    .frame(width: 120, height: 120)
                    .scaleEffect(speechRecognizer.isRecording ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: speechRecognizer.isRecording)

                Image(systemName: speechRecognizer.isRecording ? "mic.fill" : "mic.slash.fill")
                    .font(.system(size: 50))
                    .foregroundColor(speechRecognizer.isRecording ? .red : .gray)
            }

            Text(speechRecognizer.isRecording ? "Recording..." : "Ready to Record")
                .font(.headline)
                .foregroundColor(speechRecognizer.isRecording ? .red : .primary)

            if speechRecognizer.isRecording {
                Text(formatDuration(speechRecognizer.recordingDuration))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .monospacedDigit()
            }
        }
        .padding()
    }

    private var transcriptTextView: some View {
        Group {
            if !speechRecognizer.transcript.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Transcript")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    Text(speechRecognizer.transcript)
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }
            } else if !speechRecognizer.isRecording {
                VStack(spacing: 10) {
                    Image(systemName: "text.bubble")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)

                    Text("Tap the button below to start recording")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
        }
    }

    private var controlButtons: some View {
        VStack(spacing: 15) {
            HStack(spacing: 20) {
                // Stop/Start button
                Button(action: {
                    if speechRecognizer.isRecording {
                        speechRecognizer.stopRecording()
                    } else {
                        speechRecognizer.startRecording()
                    }
                }) {
                    Label(
                        speechRecognizer.isRecording ? "Stop" : "Start Recording",
                        systemImage: speechRecognizer.isRecording ? "stop.circle.fill" : "mic.circle.fill"
                    )
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(speechRecognizer.isRecording ? Color.red : Color.blue)
                    .cornerRadius(12)
                }
            }

            // Save and Clear buttons
            if !speechRecognizer.transcript.isEmpty && !speechRecognizer.isRecording {
                HStack(spacing: 15) {
                    Button(action: saveTranscript) {
                        Label("Save", systemImage: "square.and.arrow.down.fill")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(12)
                    }

                    Button(action: {
                        speechRecognizer.reset()
                    }) {
                        Label("Clear", systemImage: "trash.fill")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(12)
                    }
                }
            }
        }
        .padding()
    }

    // MARK: - Helper Methods

    private func saveTranscript() {
        let newTranscript = Transcript(
            text: speechRecognizer.transcript,
            duration: speechRecognizer.recordingDuration
        )
        transcriptStore.addTranscript(newTranscript)
        savedTranscriptId = newTranscript.id
        showingSaveSheet = true
        speechRecognizer.reset()
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    RecordingView()
        .environmentObject(TranscriptStore())
}
