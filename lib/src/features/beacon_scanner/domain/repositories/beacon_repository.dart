import 'package:ibeacon_wrapper/ibeacon_wrapper.dart';

import '../entities/beacon_device.dart';

abstract class BeaconRepository {
  Stream<List<BeaconDevice>> observeBeacons();

  Stream<ScannerStatus> observeScannerStatus();

  Future<void> initializeScanner();

  Future<void> startScanning();

  Future<void> stopScanning();

  Future<void> dispose();
}
