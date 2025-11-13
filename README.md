# Voice Stenogram

A native iOS app that converts voice to text (stenogram) with real-time transcription, transcript management, AI-powered summaries, and export capabilities.

## Features

- **Real-time Voice Transcription**: Uses Apple's Speech framework for accurate speech-to-text conversion
- **Save & Manage Transcripts**: Store all your transcripts locally on your device
- **AI-Powered Summaries**: Generate concise summaries of your transcripts
- **Export Options**: Export transcripts as Text or PDF files
- **Share Functionality**: Share your transcripts via any iOS sharing option
- **Privacy-Focused**: All data stored locally on your device

## Requirements

- iOS 16.0 or later
- Xcode 15.0 or later
- iPhone or iPad with microphone
- macOS for development

## Installation & Setup

### Option 1: Open in Xcode (Recommended)

1. **Clone or download this repository**

2. **Open Xcode** (download from Mac App Store if needed)

3. **Create a new Xcode project**:
   - Open Xcode
   - Click "Create New Project"
   - Select "iOS" → "App"
   - Click "Next"

4. **Configure the project**:
   - Product Name: `VoiceStenogram`
   - Team: Select your Apple Developer account (or "None" for simulator testing)
   - Organization Identifier: `com.yourname` (or any reverse domain)
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: **None** (we use UserDefaults)
   - Click "Next" and choose a location

5. **Replace the default files**:
   - In Xcode's Project Navigator (left sidebar), delete all files under "VoiceStenogram" folder
   - Drag and drop all files from this repository's `VoiceStenogram/VoiceStenogram/` folder into Xcode
   - Make sure "Copy items if needed" is checked
   - Select "VoiceStenogram" target
   - Click "Finish"

6. **Add Info.plist permissions**:
   - Select your project in the navigator
   - Click on "Info" tab
   - Verify these keys exist (they're in the Info.plist file):
     - `Privacy - Speech Recognition Usage Description`
     - `Privacy - Microphone Usage Description`

7. **Build and Run**:
   - Connect your iPhone via USB (or use Simulator)
   - Select your device from the device menu
   - Click the "Play" button (▶️) or press `Cmd + R`

### Option 2: Quick Start with Existing Xcode Project

If you already have Xcode experience:

```bash
# Navigate to the VoiceStenogram directory
cd VoiceStenogram

# Open in Xcode
open VoiceStenogram.xcodeproj
# Note: You may need to properly configure the project in Xcode first
```

## Project Structure

```
VoiceStenogram/
├── VoiceStenogram/
│   ├── App/
│   │   └── VoiceStenogramApp.swift      # Main app entry point
│   ├── Views/
│   │   ├── ContentView.swift            # Main tab navigation
│   │   ├── RecordingView.swift          # Voice recording interface
│   │   ├── TranscriptListView.swift     # List of saved transcripts
│   │   └── TranscriptDetailView.swift   # Transcript details & editing
│   ├── Models/
│   │   ├── Transcript.swift             # Transcript data model
│   │   └── TranscriptStore.swift        # Data persistence
│   ├── Services/
│   │   ├── SpeechRecognizer.swift       # Speech-to-text service
│   │   └── SummaryGenerator.swift       # AI summary generation
│   ├── Utils/
│   │   └── ExportManager.swift          # Export functionality
│   └── Resources/
│       └── Info.plist                   # App configuration & permissions
└── Package.swift                         # Swift Package configuration
```

## Usage

### Recording a Transcript

1. Launch the app
2. Grant microphone and speech recognition permissions when prompted
3. Tap the **"Start Recording"** button
4. Speak clearly into your device's microphone
5. Watch as your speech is transcribed in real-time
6. Tap **"Stop"** when finished
7. Review your transcript
8. Tap **"Save"** to store it

### Managing Transcripts

1. Switch to the **"Transcripts"** tab
2. View all saved transcripts
3. Tap any transcript to view details
4. Edit title or text as needed
5. Swipe left to delete unwanted transcripts

### Generating Summaries

1. Open any saved transcript
2. Tap **"Generate"** next to the Summary section
3. Wait a moment while the summary is generated
4. View the AI-generated summary

**Note**: The current implementation uses a basic extractive summary. For production-grade AI summaries, integrate OpenAI or Claude API (see code comments in `SummaryGenerator.swift`).

### Exporting Transcripts

1. Open any transcript
2. Scroll to the **"Export"** section
3. Choose your format:
   - **Text**: Plain text file (.txt)
   - **PDF**: Formatted PDF document (.pdf)
4. Use iOS share sheet to save or send

## Permissions

The app requires two permissions:

1. **Microphone Access**: To record your voice
2. **Speech Recognition**: To convert speech to text

Both permissions are requested on first use and can be managed in iOS Settings.

## Troubleshooting

### Speech Recognition Not Working

- Ensure permissions are granted in Settings → Privacy → Speech Recognition
- Check microphone permissions in Settings → Privacy → Microphone
- Verify you have an active internet connection (required for first-time setup)
- Try restarting the app

### Build Errors in Xcode

- Ensure you're using Xcode 15.0 or later
- Clean build folder: Product → Clean Build Folder (Shift + Cmd + K)
- Verify deployment target is set to iOS 16.0 or later
- Check that all Swift files are added to the target

### App Won't Install on Device

- Ensure your device is running iOS 16.0 or later
- Sign in with your Apple ID in Xcode preferences
- Select your Apple ID as the "Team" in project settings
- Trust your developer certificate on the device: Settings → General → Device Management

## Customization

### Change Language

Edit `SpeechRecognizer.swift:19`:

```swift
private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
```

Replace `"en-US"` with your desired locale:
- `"es-ES"` - Spanish
- `"fr-FR"` - French
- `"de-DE"` - German
- `"ja-JP"` - Japanese
- `"zh-CN"` - Chinese (Simplified)

### Integrate AI API for Summaries

See commented code in `SummaryGenerator.swift` for OpenAI integration example. You'll need:

1. An OpenAI API key
2. Uncomment the `generateAISummary` function
3. Update UI to use the API version

### Change App Icon & Name

1. In Xcode, select "Assets" folder
2. Add AppIcon image set (1024x1024 required)
3. Update display name in Info.plist

## Technologies Used

- **SwiftUI**: Modern declarative UI framework
- **Speech Framework**: Apple's speech recognition API
- **AVFoundation**: Audio recording and processing
- **PDFKit**: PDF generation
- **Combine**: Reactive programming (via @Published)

## Privacy & Data

- All transcripts stored locally using UserDefaults
- No data sent to external servers (except Apple's Speech API for recognition)
- Export files stored in temporary directory
- No analytics or tracking

## Limitations

- Speech recognition requires internet for initial setup
- Recognition accuracy depends on:
  - Audio quality
  - Speaking clarity
  - Background noise
  - Accent and pronunciation
- Summary generation is basic (upgrade to AI API recommended)
- Storage limited by device capacity

## Future Enhancements

- [ ] Cloud sync (iCloud)
- [ ] Multiple language support in UI
- [ ] Audio file import and transcription
- [ ] Advanced AI summaries (OpenAI/Claude integration)
- [ ] Tags and categories
- [ ] Search functionality
- [ ] Dark mode customization
- [ ] Apple Watch companion app
- [ ] Siri shortcuts integration

## License

This project is provided as-is for educational and personal use.

## Support

For issues or questions:
1. Check the Troubleshooting section above
2. Review Apple's Speech Framework documentation
3. Check Xcode console for error messages

## Credits

Built with Swift, SwiftUI, and Apple's Speech Framework.

---

**Version**: 1.0
**Last Updated**: November 2024
**Minimum iOS**: 16.0