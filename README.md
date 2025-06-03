# Word Search Game
A feature-rich Word Search puzzle game built with Flutter

## Core Game Features

- Dynamic Grid Generation: Automatically generates grids with hidden words placed in multiple directions
- Multiple Difficulty Levels:
    - Easy (8x8 grid, 8 words, 10 minutes)
    - Medium (12x12 grid, 10 words, 15 minutes)
    - Hard (16x16 grid, 12 words, 20 minutes)
- Word Placement: Words hidden horizontally, vertically, and diagonally (both directions)
- Interactive Selection: Tap and drag to select letters and form words
- Real-time Validation: Instant feedback when words are found
- Visual Feedback: Selected letters are highlighted, found words are marked differently

## Game Mechanics
- Scoring System: Points based on word length, difficulty multiplier, and time bonus
- Timer: Countdown timer with different limits per difficulty
Progress Tracking: Real-time display of found words vs total words
- Game States: Start, pause, resume, and completion handling
- App Lifecycle Management: Automatic pause when app goes to background

## User Interface

- Responsive Design: Adapts to different screen sizes and orientations
- Material Design 3: Modern UI with light and dark theme support
- Smooth Animations: Fluid transitions and visual feedback
- Accessibility: Proper contrast ratios and semantic markup
- Intuitive Controls: Easy-to-use touch gestures

## Additional Features
- Hint System: Get hints for unfound words
- Game Menu: Pause, restart, or return to home during gameplay
- Results Screen: Comprehensive game completion summary
- Word List Display: Visual representation of words to find with completion status

## Screenshots
Game runs beautifully on Android, iOS, and Web platforms

## Technical Architecture
- Project Structure
```bash
lib/
├── main.dart                 # App entry point
├── models/
│   └── game_models.dart     # Data models (Position, WordPlacement, GameConfig)
├── providers/
│   └── game_provider.dart   # Game state management with ChangeNotifier
├── screens/
│   ├── home_screen.dart     # Main menu with difficulty selection
│   └── game_screen.dart     # Main game interface
├── widgets/
│   ├── game_grid.dart       # Interactive letter grid component
│   ├── word_list.dart       # Word list display component
│   └── game_stats.dart      # Game statistics display
└── utils/
    └── app_theme.dart       # Theme configuration Key Design Patterns
```
- Provider Pattern: State management using provider package
- Component-Based Architecture: Reusable, modular widgets
- Separation of Concerns: Clear distinction between UI, logic, and data
- Responsive Design: Adaptive layouts for different screen sizes

## Getting Started
### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code with Flutter extensions
- For iOS development: Xcode and iOS Simulator

### Installation

1. Clone the repository
```bash
git clone https://github.com/nieyangfei/words_search_game
cd word_search_game
```

2. Install dependencies
```bash
flutter pub get
```
3. Run the app
    - For debug mode
    ```bash
    flutter run
    ```

    - For specific platform
    ```bash
    flutter run -d chrome    # Web
    flutter run -d android   # Android
    flutter run -d ios       # iOS
    ```
    - Build for Production
        - Android APK
        ```bash
        flutter build apk --release
        ```

        - Android App Bundle
        ```bash
        flutter build appbundle --release
        ```

        - iOS
        ```bash
        flutter build ios --release
        ```
        - Web
        ```bash
        flutter build web --release
        ```