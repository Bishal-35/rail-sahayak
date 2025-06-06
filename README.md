# Rail Sahayak

A Flutter application designed to assist rail travelers with various services and information.

## Project Description

Rail Sahayak provides users with features such as:

- Train schedules and live status
- Booking information
- Station details
- Travel alerts
- And more...

## Prerequisites

Before you begin, ensure you have the following installed:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (2.0 or higher recommended)
- [Dart SDK](https://dart.dev/get-dart) (latest stable version)
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/) with Flutter extensions
- [Git](https://git-scm.com/downloads) for version control
- An emulator/simulator or physical device for testing

## Installation

1. Clone the repository:

   ```
   git clone https://github.com/username/rail-sahayak.git
   cd rail-sahayak
   ```

2. Install dependencies:

   ```
   flutter pub get
   ```

3. Configure environment variables (if applicable):
   - Create `.env` file in the project root (see `.env.example` for reference)

## Running the Application

### Development

```
flutter run
```

This will launch the app on the connected device or available emulator.

### Build Release APK

```
flutter build apk
```

The built APK will be available at `build/app/outputs/flutter-apk/app-release.apk`

### Build for iOS

```
flutter build ios
```

Then open the iOS project in Xcode to archive and distribute.

## Testing

Run the tests using:

```
flutter test
```

## Additional Resources

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Flutter documentation](https://docs.flutter.dev/)

## Troubleshooting

If you encounter any issues:

1. Run `flutter doctor` to diagnose common Flutter issues
2. Check if dependencies are up to date with `flutter pub outdated`
3. Clean the project with `flutter clean` and then `flutter pub get`

## Security Notes

### API Keys and Sensitive Information

This project uses Firebase services which require API keys. For security reasons:

1. The actual `google-services.json` file is not included in the repository
2. Use the provided `google-services.json.template` as a reference
3. When setting up the project:
   - Create your own Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Download your own `google-services.json` and place it in `android/app/`
   - Never commit your actual API keys to version control
   - For CI/CD pipelines, use environment variables or secure storage
