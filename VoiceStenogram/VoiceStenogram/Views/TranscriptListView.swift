//
//  TranscriptListView.swift
//  VoiceStenogram
//
//  List view showing all saved transcripts
//

import SwiftUI

struct TranscriptListView: View {
    @EnvironmentObject var transcriptStore: TranscriptStore
    @State private var selectedTranscript: Transcript?
    @State private var showingDetail = false

    var body: some View {
        NavigationView {
            Group {
                if transcriptStore.transcripts.isEmpty {
                    emptyStateView
                } else {
                    List {
                        ForEach(transcriptStore.transcripts) { transcript in
                            TranscriptRow(transcript: transcript)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedTranscript = transcript
                                    showingDetail = true
                                }
                        }
                        .onDelete(perform: transcriptStore.deleteTranscripts)
                    }
                }
            }
            .navigationTitle("Transcripts")
            .toolbar {
                if !transcriptStore.transcripts.isEmpty {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingDetail) {
                if let transcript = selectedTranscript {
                    TranscriptDetailView(transcript: transcript)
                }
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 80))
                .foregroundColor(.gray)

            Text("No Transcripts Yet")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Start recording to create your first transcript")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct TranscriptRow: View {
    let transcript: Transcript

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(transcript.title)
                    .font(.headline)

                Spacer()

                if transcript.summary != nil {
                    Image(systemName: "doc.text.fill")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }

            Text(transcript.text)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)

            HStack {
                Label(transcript.formattedDate, systemImage: "calendar")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                Label(transcript.formattedDuration, systemImage: "clock")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    TranscriptListView()
        .environmentObject(TranscriptStore())
}
