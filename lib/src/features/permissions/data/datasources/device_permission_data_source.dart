import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/permission_snapshot_model.dart';

class DevicePermissionDataSource {
  static const Duration _permissionRequestTimeout = Duration(seconds: 8);

  Future<PermissionSnapshotModel> getStatus() async {
    final bool isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final bool isApple =
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;

    final PermissionStatus locationWhenInUse =
        await Permission.locationWhenInUse.status;
    final PermissionStatus locationAlways =
        await Permission.locationAlways.status;
    final PermissionStatus bluetoothScan = isAndroid
        ? await Permission.bluetoothScan.status
        : PermissionStatus.granted;
    final PermissionStatus bluetoothConnect = isAndroid
        ? await Permission.bluetoothConnect.status
        : PermissionStatus.granted;
    final PermissionStatus bluetooth = isApple
        ? await Permission.bluetooth.status
        : PermissionStatus.denied;

    final ServiceStatus locationService =
        await Permission.locationWhenInUse.serviceStatus;

    final bool bluetoothServiceEnabled = await _isBluetoothServiceEnabled();

    return PermissionSnapshotModel(
      locationWhenInUseGranted: _isGranted(locationWhenInUse),
      locationAlwaysGranted: _isGranted(locationAlways),
      bluetoothScanGranted: _isGranted(bluetoothScan),
      bluetoothConnectGranted: _isGranted(bluetoothConnect),
      bluetoothGranted: _isGranted(bluetooth),
      locationPermissionPermanentlyDenied:
          _isPermanentlyDenied(locationWhenInUse) ||
          _isPermanentlyDenied(locationAlways),
      bluetoothPermissionPermanentlyDenied: isApple
          ? _isPermanentlyDenied(bluetooth)
          : _isPermanentlyDenied(bluetoothScan) ||
                _isPermanentlyDenied(bluetoothConnect),
      locationServiceEnabled: locationService.isEnabled,
      bluetoothServiceEnabled: bluetoothServiceEnabled,
    );
  }

  Future<PermissionSnapshotModel> requestAll() async {
    final bool isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final bool isApple =
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;

    if (!kIsWeb && isAndroid) {
      if (await _hasHardDeniedPermissionsForCurrentPlatform()) {
        return getStatus();
      }

      Map<Permission, PermissionStatus> firstRound;
      try {
        firstRound = await <Permission>[
          Permission.bluetoothScan,
          Permission.bluetoothConnect,
          Permission.locationWhenInUse,
        ].request();
      } catch (_) {
        return getStatus();
      }

      // On Android, background location can only be requested safely after
      // foreground location has already been granted.
      if (_isGranted(firstRound[Permission.locationWhenInUse])) {
        await _requestBackgroundLocationIfNeeded();
      }
    } else if (!kIsWeb && isApple) {
      if (await _hasHardDeniedPermissionsForCurrentPlatform()) {
        return getStatus();
      }

      Map<Permission, PermissionStatus> firstRound;
      try {
        firstRound = await <Permission>[
          Permission.bluetooth,
          Permission.locationWhenInUse,
        ].request();
      } catch (_) {
        return getStatus();
      }

      if (_isGranted(firstRound[Permission.locationWhenInUse])) {
        await _requestBackgroundLocationIfNeeded();
      }
    }

    return getStatus();
  }

  bool _isGranted(PermissionStatus? status) {
    if (status == null) {
      return false;
    }
    return status.isGranted || status.isLimited;
  }

  bool _isPermanentlyDenied(PermissionStatus? status) {
    if (status == null) {
      return false;
    }
    return status.isPermanentlyDenied || status.isRestricted;
  }

  Future<bool> _hasHardDeniedPermissionsForCurrentPlatform() async {
    if (kIsWeb) {
      return false;
    }

    final bool isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final bool isApple =
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;

    if (isAndroid) {
      final PermissionStatus bluetoothScan =
          await Permission.bluetoothScan.status;
      final PermissionStatus bluetoothConnect =
          await Permission.bluetoothConnect.status;
      final PermissionStatus locationWhenInUse =
          await Permission.locationWhenInUse.status;
      final PermissionStatus locationAlways =
          await Permission.locationAlways.status;

      return _isPermanentlyDenied(bluetoothScan) ||
          _isPermanentlyDenied(bluetoothConnect) ||
          _isPermanentlyDenied(locationWhenInUse) ||
          _isPermanentlyDenied(locationAlways);
    }

    if (isApple) {
      final PermissionStatus bluetooth = await Permission.bluetooth.status;
      final PermissionStatus locationWhenInUse =
          await Permission.locationWhenInUse.status;
      final PermissionStatus locationAlways =
          await Permission.locationAlways.status;

      return _isPermanentlyDenied(bluetooth) ||
          _isPermanentlyDenied(locationWhenInUse) ||
          _isPermanentlyDenied(locationAlways);
    }

    return false;
  }

  Future<void> _requestBackgroundLocationIfNeeded() async {
    try {
      final PermissionStatus current = await Permission.locationAlways.status;
      if (_isGranted(current) || _isPermanentlyDenied(current)) {
        return;
      }

      await Permission.locationAlways.request().timeout(
        _permissionRequestTimeout,
        onTimeout: () => current,
      );
    } catch (_) {
      // Some Android builds reject background-location requests depending on
      // current policy state. We treat this as a denied state and keep running.
    }
  }

  Future<bool> _isBluetoothServiceEnabled() async {
    if (kIsWeb) {
      return true;
    }

    final bool isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final bool isApple =
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;

    if (isAndroid) {
      return true;
    }

    try {
      final ServiceStatus serviceStatus = isApple
          ? await Permission.bluetooth.serviceStatus
          : ServiceStatus.enabled;
      return serviceStatus.isEnabled;
    } catch (_) {
      return true;
    }
  }
}
