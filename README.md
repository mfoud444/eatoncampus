# eatoncampus



## Getting Started

To get started with Construction, follow these steps:

### Prerequisites

- Flutter SDK installed on your machine
- Android Studio or Xcode (for iOS development)
- Firebase account (for authentication and other features)

### Installation

1. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/mfoud444/eatoncampus.git
   ```

2. Navigate to the project directory:

   ```bash
   cd eatoncampus
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Add Firebase to your Flutter project by following the instructions provided by Firebase. This usually involves creating a project in the Firebase console and downloading the `google-services.json` file for Android and `GoogleService-Info.plist` file for iOS.

   Once you have obtained the `google-services.json` file, place it in the `android/app` directory of your Flutter project.

### Building the APK

To build the APK for Android, run the following command:

```bash
flutter build apk
```

The generated APK file will be located in the `build/app/outputs/flutter-apk/` directory.

For more information about building APKs in Flutter, refer to the [official documentation](https://flutter.dev/docs/deployment/android).

### Running the App

To run the app on a connected device or emulator, use the following command:

```bash
flutter run
```

This will compile the app and install it on the connected device or emulator.



## Contributing

Contributions are welcome! Please feel free to submit a pull request.

## License

This project is licensed under the [GNU General Public License v3.0](LICENSE).


