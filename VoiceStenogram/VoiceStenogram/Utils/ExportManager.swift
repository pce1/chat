//
//  ExportManager.swift
//  VoiceStenogram
//
//  Handles exporting transcripts in various formats
//

import UIKit
import PDFKit

class ExportManager {

    /// Export transcript as plain text
    static func exportAsText(_ transcript: Transcript) -> URL? {
        let fileName = "\(transcript.title).txt"
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

        var content = """
        Title: \(transcript.title)
        Date: \(transcript.formattedDate)
        Duration: \(transcript.formattedDuration)

        TRANSCRIPT:
        \(transcript.text)
        """

        if let summary = transcript.summary {
            content += """


            SUMMARY:
            \(summary)
            """
        }

        do {
            try content.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        } catch {
            print("Error exporting text: \(error)")
            return nil
        }
    }

    /// Export transcript as PDF
    static func exportAsPDF(_ transcript: Transcript) -> URL? {
        let fileName = "\(transcript.title).pdf"
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

        let pageSize = CGRect(x: 0, y: 0, width: 612, height: 792) // US Letter
        let renderer = UIGraphicsPDFRenderer(bounds: pageSize)

        let data = renderer.pdfData { context in
            context.beginPage()

            let titleFont = UIFont.boldSystemFont(ofSize: 20)
            let bodyFont = UIFont.systemFont(ofSize: 12)
            let metaFont = UIFont.italicSystemFont(ofSize: 10)

            var yPosition: CGFloat = 40
            let margin: CGFloat = 40
            let maxWidth = pageSize.width - (margin * 2)

            // Title
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: titleFont,
                .foregroundColor: UIColor.black
            ]
            let titleString = transcript.title
            let titleRect = CGRect(x: margin, y: yPosition, width: maxWidth, height: 30)
            titleString.draw(in: titleRect, withAttributes: titleAttributes)
            yPosition += 35

            // Metadata
            let metaAttributes: [NSAttributedString.Key: Any] = [
                .font: metaFont,
                .foregroundColor: UIColor.gray
            ]
            let metaString = "Date: \(transcript.formattedDate) | Duration: \(transcript.formattedDuration)"
            let metaRect = CGRect(x: margin, y: yPosition, width: maxWidth, height: 20)
            metaString.draw(in: metaRect, withAttributes: metaAttributes)
            yPosition += 30

            // Separator
            let separator = UIBezierPath()
            separator.move(to: CGPoint(x: margin, y: yPosition))
            separator.addLine(to: CGPoint(x: pageSize.width - margin, y: yPosition))
            UIColor.lightGray.setStroke()
            separator.stroke()
            yPosition += 20

            // Transcript text
            let bodyAttributes: [NSAttributedString.Key: Any] = [
                .font: bodyFont,
                .foregroundColor: UIColor.black
            ]

            let transcriptLabel = "TRANSCRIPT:\n"
            let transcriptLabelRect = CGRect(x: margin, y: yPosition, width: maxWidth, height: 20)
            transcriptLabel.draw(in: transcriptLabelRect, withAttributes: [.font: UIFont.boldSystemFont(ofSize: 12)])
            yPosition += 25

            let textRect = CGRect(x: margin, y: yPosition, width: maxWidth, height: pageSize.height - yPosition - margin)
            transcript.text.draw(in: textRect, withAttributes: bodyAttributes)

            // Summary on new page if available
            if let summary = transcript.summary {
                context.beginPage()
                yPosition = 40

                let summaryLabel = "SUMMARY:\n"
                let summaryLabelRect = CGRect(x: margin, y: yPosition, width: maxWidth, height: 20)
                summaryLabel.draw(in: summaryLabelRect, withAttributes: [.font: UIFont.boldSystemFont(ofSize: 12)])
                yPosition += 25

                let summaryRect = CGRect(x: margin, y: yPosition, width: maxWidth, height: pageSize.height - yPosition - margin)
                summary.draw(in: summaryRect, withAttributes: bodyAttributes)
            }
        }

        do {
            try data.write(to: fileURL)
            return fileURL
        } catch {
            print("Error exporting PDF: \(error)")
            return nil
        }
    }
}
