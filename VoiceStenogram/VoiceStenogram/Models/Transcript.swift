//
//  Transcript.swift
//  VoiceStenogram
//
//  Data model for voice transcripts
//

import Foundation

struct Transcript: Identifiable, Codable {
    let id: UUID
    var title: String
    var text: String
    var summary: String?
    let createdAt: Date
    var updatedAt: Date
    var duration: TimeInterval

    init(id: UUID = UUID(), title: String = "", text: String = "", summary: String? = nil, createdAt: Date = Date(), updatedAt: Date = Date(), duration: TimeInterval = 0) {
        self.id = id
        self.title = title.isEmpty ? "Transcript \(Self.dateFormatter.string(from: createdAt))" : title
        self.text = text
        self.summary = summary
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.duration = duration
    }

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    var formattedDate: String {
        Self.dateFormatter.string(from: createdAt)
    }

    var formattedDuration: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
