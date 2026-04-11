import 'package:ibeacon_wrapper/ibeacon_wrapper.dart';

class IBeaconDataSource {
  IBeaconDataSource({required IBeaconScanner scanner}) : _scanner = scanner;

  final IBeaconScanner _scanner;

  Stream<List<BeaconSignal>> rawBeaconStream() => _scanner.beaconStream;

  Stream<ScannerStatus> scannerStatusStream() => _scanner.statusStream;

  Future<void> initialize() => _scanner.initialize();

  Future<void> start() => _scanner.start();

  Future<void> stop() => _scanner.stop();

  Future<void> dispose() => _scanner.dispose();
}
