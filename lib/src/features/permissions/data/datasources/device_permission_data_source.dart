import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/permission_snapshot_model.dart';

class DevicePermissionDataSource {
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
      await <Permission>[
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.locationWhenInUse,
      ].request();
      await Permission.locationAlways.request();
    } else if (!kIsWeb && isApple) {
      await <Permission>[
        Permission.bluetooth,
        Permission.locationWhenInUse,
      ].request();
      await Permission.locationAlways.request();
    }

    return getStatus();
  }

  bool _isGranted(PermissionStatus status) {
    return status.isGranted || status.isLimited;
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
