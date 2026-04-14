import 'package:equatable/equatable.dart';

class PermissionSnapshot extends Equatable {
  const PermissionSnapshot({
    required this.locationWhenInUseGranted,
    required this.locationAlwaysGranted,
    required this.bluetoothScanGranted,
    required this.bluetoothConnectGranted,
    required this.bluetoothGranted,
    required this.locationPermissionPermanentlyDenied,
    required this.bluetoothPermissionPermanentlyDenied,
    required this.locationServiceEnabled,
    required this.bluetoothServiceEnabled,
  });

  final bool locationWhenInUseGranted;
  final bool locationAlwaysGranted;
  final bool bluetoothScanGranted;
  final bool bluetoothConnectGranted;
  final bool bluetoothGranted;
  final bool locationPermissionPermanentlyDenied;
  final bool bluetoothPermissionPermanentlyDenied;
  final bool locationServiceEnabled;
  final bool bluetoothServiceEnabled;

  bool get hasPermanentlyDeniedPermission =>
      locationPermissionPermanentlyDenied ||
      bluetoothPermissionPermanentlyDenied;

  bool get hasLocationPermission =>
      locationWhenInUseGranted && locationAlwaysGranted;

  bool get hasBluetoothPermission =>
      bluetoothGranted || (bluetoothScanGranted && bluetoothConnectGranted);

  bool get isReady =>
      hasLocationPermission &&
      hasBluetoothPermission &&
      locationServiceEnabled &&
      bluetoothServiceEnabled;

  @override
  List<Object?> get props => <Object?>[
    locationWhenInUseGranted,
    locationAlwaysGranted,
    bluetoothScanGranted,
    bluetoothConnectGranted,
    bluetoothGranted,
    locationPermissionPermanentlyDenied,
    bluetoothPermissionPermanentlyDenied,
    locationServiceEnabled,
    bluetoothServiceEnabled,
  ];
}
