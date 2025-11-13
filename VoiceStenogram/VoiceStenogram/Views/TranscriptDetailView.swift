//
//  TranscriptDetailView.swift
//  VoiceStenogram
//
//  Detailed view of a single transcript with edit, summary, and export options
//

import SwiftUI

struct TranscriptDetailView: View {
    @EnvironmentObject var transcriptStore: TranscriptStore
    @Environment(\.dismiss) var dismiss

    var transcript: Transcript

    @State private var editedTitle: String
    @State private var editedText: String
    @State private var isGeneratingSummary = false
    @State private var showingShareSheet = false
    @State private var shareURL: URL?
    @State private var exportFormat: ExportFormat = .text

    init(transcript: Transcript) {
        self.transcript = transcript
        _editedTitle = State(initialValue: transcript.title)
        _editedText = State(initialValue: transcript.text)
    }

    enum ExportFormat {
        case text, pdf
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Metadata
                    metadataSection

                    Divider()

                    // Title editor
                    titleSection

                    // Transcript text editor
                    transcriptSection

                    // Summary section
                    summarySection

                    // Export buttons
                    exportSection
                }
                .padding()
            }
            .navigationTitle("Transcript Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        saveChanges()
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                if let url = shareURL {
                    ShareSheet(items: [url])
                }
            }
        }
    }

    // MARK: - Subviews

    private var metadataSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label(transcript.formattedDate, systemImage: "calendar")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Spacer()

                Label(transcript.formattedDuration, systemImage: "clock")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Title")
                .font(.headline)

            TextField("Transcript title", text: $editedTitle)
                .textFieldStyle(.roundedBorder)
        }
    }

    private var transcriptSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Transcript")
                .font(.headline)

            TextEditor(text: $editedText)
                .frame(minHeight: 200)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
        }
    }

    private var summarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Summary")
                    .font(.headline)

                Spacer()

                if transcript.summary == nil {
                    Button(action: generateSummary) {
                        if isGeneratingSummary {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Label("Generate", systemImage: "sparkles")
                                .font(.subheadline)
                        }
                    }
                    .buttonStyle(.bordered)
                    .disabled(isGeneratingSummary || editedText.isEmpty)
                }
            }

            if let summary = transcript.summary {
                VStack(alignment: .leading, spacing: 8) {
                    Text(summary)
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)

                    Button(action: generateSummary) {
                        Label("Regenerate Summary", systemImage: "arrow.clockwise")
                            .font(.caption)
                    }
                    .buttonStyle(.borderless)
                    .disabled(isGeneratingSummary)
                }
            } else {
                Text("No summary generated yet")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .italic()
            }
        }
    }

    private var exportSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Export")
                .font(.headline)

            HStack(spacing: 12) {
                Button(action: { exportTranscript(format: .text) }) {
                    Label("Text", systemImage: "doc.text")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Button(action: { exportTranscript(format: .pdf) }) {
                    Label("PDF", systemImage: "doc.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        }
    }

    // MARK: - Helper Methods

    private func saveChanges() {
        var updatedTranscript = transcript
        updatedTranscript.title = editedTitle
        updatedTranscript.text = editedText
        updatedTranscript.updatedAt = Date()
        transcriptStore.updateTranscript(updatedTranscript)
    }

    private func generateSummary() {
        isGeneratingSummary = true

        Task {
            let summary = await SummaryGenerator.generateSummary(from: editedText)

            await MainActor.run {
                var updatedTranscript = transcript
                updatedTranscript.summary = summary
                updatedTranscript.updatedAt = Date()
                transcriptStore.updateTranscript(updatedTranscript)
                isGeneratingSummary = false
            }
        }
    }

    private func exportTranscript(format: ExportFormat) {
        // Save current changes first
        saveChanges()

        // Get updated transcript
        guard let updatedTranscript = transcriptStore.transcripts.first(where: { $0.id == transcript.id }) else {
            return
        }

        let url: URL?
        switch format {
        case .text:
            url = ExportManager.exportAsText(updatedTranscript)
        case .pdf:
            url = ExportManager.exportAsPDF(updatedTranscript)
        }

        if let url = url {
            shareURL = url
            showingShareSheet = true
        }
    }
}

// MARK: - Share Sheet

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    TranscriptDetailView(transcript: Transcript(
        title: "Sample Transcript",
        text: "This is a sample transcript text. It contains multiple sentences. This helps demonstrate the layout.",
        summary: "This is a sample summary of the transcript.",
        duration: 125
    ))
    .environmentObject(TranscriptStore())
}
