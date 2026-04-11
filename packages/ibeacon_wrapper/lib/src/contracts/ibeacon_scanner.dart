import '../entities/beacon_signal.dart';
import '../entities/scanner_status.dart';

abstract class IBeaconScanner {
  Stream<List<BeaconSignal>> get beaconStream;
  Stream<ScannerStatus> get statusStream;

  Future<void> initialize();
  Future<void> start();
  Future<void> stop();
  Future<void> requestPermissions();
  Future<void> dispose();
}
