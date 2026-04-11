import '../../domain/entities/permission_snapshot.dart';

class PermissionSnapshotModel extends PermissionSnapshot {
  const PermissionSnapshotModel({
    required super.locationWhenInUseGranted,
    required super.locationAlwaysGranted,
    required super.bluetoothScanGranted,
    required super.bluetoothConnectGranted,
    required super.bluetoothGranted,
    required super.locationServiceEnabled,
    required super.bluetoothServiceEnabled,
  });
}
