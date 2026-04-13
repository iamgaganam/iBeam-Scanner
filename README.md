# ProxiMate

Proximity-aware Flutter application built with Clean Architecture, Bloc, Firebase SSO, and a dedicated iBeacon wrapper package.

## What Is Implemented

- Clean Architecture feature slices: Data, Domain, Presentation.
- Bloc state management for Auth, Permissions, Beacon Scanner, and Alerts.
- Dependency Injection with GetIt.
- Firebase SSO:
  - Google sign-in
  - Apple sign-in
  - Reactive auth stream with AuthGate behavior
- iBeacon wrapper package (`packages/ibeacon_wrapper`) that abstracts scanner implementation from app domain logic.
- RSSI smoothing using moving average.
- Distance estimation using the requested curve-fit algorithm:
  - `ratio = RSSI / TX_Power`
  - `ratio < 1.0 => ratio^10`
  - `ratio >= 1.0 => 0.89976 * ratio^7.7095 + 0.111`
- Proximity notifications:
  - Background detection notification
  - 5-meter threshold notification
- Alert screen fully data-driven from attached JSON dataset with simulated 2-second latency.
- Alert Bloc transitions:
  - `AlertLoading -> AlertLoaded`
  - `AlertLoading -> AlertError`
- Platform permissions and background declarations for Android and iOS.
- Unit tests for distance estimation and smoothing.

## Architecture Summary

```text
lib/src/
  app/
    app.dart
    di/injector.dart
    widgets/auth_gate.dart
  core/
    error/
    services/local_notification_service.dart
    presentation/widgets/
  features/
    auth/
    permissions/
    beacon_scanner/
    alerts/
    settings/
    app_shell/

packages/ibeacon_wrapper/lib/src/
  contracts/ibeacon_scanner.dart
  adapters/flutter_blue_ibeacon_scanner.dart
  adapters/mock_ibeacon_scanner.dart
  adapters/failover_ibeacon_scanner.dart
  entities/
  utils/
```

## iBeacon Wrapper Design

The app never talks directly to scanner plugins from feature domain/presentation layers.

- Contract: `IBeaconScanner`
- Primary adapter: `FlutterBlueIBeaconScanner` (real BLE scan + iBeacon packet parsing)
- Fallback adapter: `MockIBeaconScanner` (for development/testing without hardware)
- Failover wrapper: `FailoverIBeaconScanner` (automatically switches to mock if real scanner is unsupported/fails)

This keeps domain logic agnostic to scanner vendor/package changes.

## Alerts Dataset

The provided JSON is integrated as an app asset:

- `assets/data/alerts.json`

The data source intentionally delays loading by 2 seconds before returning data.

## Firebase Setup (Required For Real SSO)

1. Create a Firebase project and add Android/iOS apps.
2. Add platform config files:
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`
3. Enable providers in Firebase Authentication:
   - Google
   - Apple
4. For Apple sign-in on iOS, enable the Sign in with Apple capability in Xcode for Runner.

Without Firebase platform files, app compiles and runs, but SSO will fail at runtime.

## Platform Permissions & Background

### Android

Declared in `android/app/src/main/AndroidManifest.xml`:

- BLE permissions (`BLUETOOTH_SCAN`, `BLUETOOTH_CONNECT`, legacy bluetooth)
- Location permissions (`ACCESS_FINE_LOCATION`, `ACCESS_BACKGROUND_LOCATION`)
- Notifications (`POST_NOTIFICATIONS`)
- Foreground service permissions (`FOREGROUND_SERVICE`, `FOREGROUND_SERVICE_LOCATION`)

### iOS

Declared in `ios/Runner/Info.plist`:

- `NSBluetoothAlwaysUsageDescription`
- `NSLocationWhenInUseUsageDescription`
- `NSLocationAlwaysAndWhenInUseUsageDescription`
- Background modes: `bluetooth-central`, `location`

## Run Instructions

```bash
flutter pub get
flutter run
```

## Quality Checks

```bash
flutter analyze
flutter test
```

Current status:

- `flutter analyze`: passes
- `flutter test`: passes

## Notes

- UI design was preserved and connected to backend/state logic.
- If no physical beacon is available, scanner fallback simulation keeps the dashboard functional for demonstration.
- Once a real iBeacon device is available, the real scanner path can be used without changing feature-layer code.
