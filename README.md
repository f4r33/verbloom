# Verbloom 🌱

A Flutter application designed to help users expand their vocabulary through an engaging and interactive learning experience.

## Features

- **Learn Rare Words**: Discover and master uncommon words to expand your vocabulary
- **Earn XP and Streaks**: Stay motivated with daily streaks and experience points
- **Unlock Challenges**: Test your knowledge with exciting word challenges
- **Multiple Authentication Options**: Sign in with email, Google, Apple, or continue as a guest

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (latest stable version)
- Firebase account (for authentication and backend services)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/verbloom.git
cd verbloom
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
   - Create a new Firebase project
   - Add Android and iOS apps to your Firebase project
   - Download and add the configuration files:
     - Android: `google-services.json` in `android/app/`
     - iOS: `GoogleService-Info.plist` in `ios/Runner/`

4. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── core/
│   ├── theme/        # App theme configuration
│   ├── routes/       # Navigation routes
│   └── constants/    # App-wide constants
├── features/
│   ├── splash/       # Splash screen
│   ├── onboarding/   # Onboarding screens
│   └── auth/         # Authentication screens
└── main.dart         # App entry point
```

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

© 2024 Verbloom
