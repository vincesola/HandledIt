# HandledIt Asset Integration Prompt

Integrate the provided HandledIt brand assets into the SwiftUI project.

Do not add OCR, EventKit, Share Extension, AI parsing, iCloud, backend, or new architecture.

## Asset tasks
1. Copy `AppIcon.appiconset` into `HandledIt/Assets.xcassets/AppIcon.appiconset`.
2. Add the brand mark PNGs into Xcode Assets if needed.
3. Keep the SwiftUI BrandMarkView as a fallback.

## Brand direction
Use the merged logo:
- Rounded indigo/purple square
- White H
- Subtle checkmark integrated into the H
- Tagline: Life, handled.

## Colors
- Primary Indigo: #4F46E5
- Accent Purple: #8B5CF6
- Mila Teal: #14B8A6
- Calm Background: #EEF2F7
- Soft Card: #F7F9FC
- Text Primary: #0F172A
- Text Secondary: #64748B
- Border: #E2E8F0

The problem is not the purple/indigo. The problem is bright white backgrounds. Avoid pure white for main backgrounds.

## Splash screen
Add a simple SwiftUI splash screen:
- 1.2 seconds
- Calm background
- centered brand mark
- app name
- tagline
- subtle fade/scale
- transition to ContentView

No Lottie dependency.

## Important
Do not collapse Swift files into one line. Rewrite full Swift files with normal multiline formatting.
