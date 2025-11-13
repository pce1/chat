//
//  SummaryGenerator.swift
//  VoiceStenogram
//
//  Generates AI-powered summaries of transcripts
//

import Foundation

class SummaryGenerator {

    /// Generates a summary using local text processing
    /// For production, you could integrate with OpenAI, Claude, or other AI APIs
    static func generateSummary(from text: String) async -> String {
        // Simple extractive summary: take first few sentences
        // In production, replace with AI API call

        if text.isEmpty {
            return "No content to summarize."
        }

        // Simulate API delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)

        let sentences = text.components(separatedBy: CharacterSet(charactersIn: ".!?"))
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        // Extract key information
        let wordCount = text.split(separator: " ").count
        let sentenceCount = sentences.count

        // Take first 3 sentences or fewer
        let summaryText = sentences.prefix(3).joined(separator: ". ")

        let stats = "📊 Stats: \(wordCount) words, \(sentenceCount) sentences"

        return """
        Summary:
        \(summaryText.isEmpty ? "No complete sentences found." : summaryText + ".")

        \(stats)

        💡 Tip: For AI-powered summaries, integrate OpenAI or Claude API.
        """
    }

    /// Example: OpenAI API integration (requires API key)
    /// Uncomment and configure to use
    /*
    static func generateAISummary(from text: String, apiKey: String) async throws -> String {
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": "You are a helpful assistant that summarizes transcripts concisely."],
                ["role": "user", "content": "Summarize this transcript in 2-3 sentences:\n\n\(text)"]
            ],
            "max_tokens": 150
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(OpenAIResponse.self, from: data)

        return response.choices.first?.message.content ?? "Unable to generate summary"
    }

    struct OpenAIResponse: Codable {
        struct Choice: Codable {
            struct Message: Codable {
                let content: String
            }
            let message: Message
        }
        let choices: [Choice]
    }
    */
}
