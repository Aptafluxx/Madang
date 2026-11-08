# Madang Restaurant

Madang is a Flutter restaurant application for discovering dishes, ordering food,
booking restaurant tables, and managing a customer profile.

## Features

- Firebase email and password authentication
- Customer onboarding and profile management
- Restaurant food categories and recommendations
- Food search
- Cart with quantity management
- Multiple payment methods and order checkout
- Order history and recent orders
- Restaurant table browsing and booking
- Order confirmation
- Persistent local preferences and cached product images
- Responsive Material UI with Madang branding

## Technology

- Flutter and Dart
- GetX for navigation, dependency injection, and state management
- Firebase Authentication
- Cloud Firestore
- Shared Preferences
- Android and iOS support

## Requirements

- Flutter 3.47 or newer
- Dart 3.13 or newer
- Firebase project configuration
- Android Studio or another Flutter-compatible Android toolchain

## Firebase Setup

The Android app uses Firebase configuration from
`android/app/google-services.json`. Other platform configurations may require
the corresponding Firebase files.

Run FlutterFire configuration when Firebase credentials need to be generated:

```sh
flutterfire configure
```

Keep Firebase service-account credentials and signing keys private.

## Run Locally

```sh
flutter pub get
flutter run
```

## Quality Checks

```sh
flutter analyze
flutter test
```

## Android Release

The release build uses the keystore configured in `android/key.properties`.
This file and the associated keystore are intentionally excluded from Git.
Build the signed Android App Bundle with:

```sh
flutter build appbundle --release
```

The output is written to:

```text
build/app/outputs/bundle/release/app-release.aab
```

To build an installable APK:

```sh
flutter build apk --release
```

## Application Information

- Application ID: `com.aptaflux.madang`
- Version: `1.0.0+1`
