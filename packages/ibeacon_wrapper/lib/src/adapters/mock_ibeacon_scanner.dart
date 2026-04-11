import 'dart:async';
import 'dart:math' as math;

import '../contracts/ibeacon_scanner.dart';
import '../entities/beacon_signal.dart';
import '../entities/scanner_status.dart';

class MockIBeaconScanner implements IBeaconScanner {
  MockIBeaconScanner({
    this.interval = const Duration(seconds: 2),
    this.randomSeed,
  }) : _random = math.Random(randomSeed);

  final Duration interval;
  final int? randomSeed;
  final math.Random _random;

  final StreamController<List<BeaconSignal>> _beaconController =
      StreamController<List<BeaconSignal>>.broadcast();
  final StreamController<ScannerStatus> _statusController =
      StreamController<ScannerStatus>.broadcast();

  Timer? _timer;
  bool _initialized = false;

  static const List<_MockBeacon> _fixtures = <_MockBeacon>[
    _MockBeacon(
      uuid: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0',
      major: 1002,
      minor: 45,
      baseRssi: -57,
      txPower: -59,
    ),
    _MockBeacon(
      uuid: 'A1221100-3344-4BC2-A901-EE203344CC89',
      major: 200,
      minor: 124,
      baseRssi: -67,
      txPower: -59,
    ),
    _MockBeacon(
      uuid: 'F4980120-E4F1-4E7B-9E33-0245648A044B',
      major: 501,
      minor: 8,
      baseRssi: -78,
      txPower: -59,
    ),
  ];

  @override
  Stream<List<BeaconSignal>> get beaconStream => _beaconController.stream;

  @override
  Stream<ScannerStatus> get statusStream => _statusController.stream;

  @override
  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    _statusController.add(ScannerStatus.initializing);
    _initialized = true;
    _statusController.add(ScannerStatus.ready);
  }

  @override
  Future<void> requestPermissions() async {
    _statusController.add(ScannerStatus.ready);
  }

  @override
  Future<void> start() async {
    if (!_initialized) {
      await initialize();
    }

    _statusController.add(ScannerStatus.scanning);
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) => _emitSample());
    _emitSample();
  }

  @override
  Future<void> stop() async {
    _timer?.cancel();
    _timer = null;
    _statusController.add(ScannerStatus.stopped);
  }

  @override
  Future<void> dispose() async {
    await stop();
    await _beaconController.close();
    await _statusController.close();
  }

  void _emitSample() {
    final DateTime now = DateTime.now();
    final List<BeaconSignal> beacons = _fixtures.map((fixture) {
      final int noise = _random.nextInt(8) - 4;
      return BeaconSignal(
        uuid: fixture.uuid,
        major: fixture.major,
        minor: fixture.minor,
        rssi: fixture.baseRssi + noise,
        txPower: fixture.txPower,
        timestamp: now,
      );
    }).toList();

    _beaconController.add(beacons);
  }
}

class _MockBeacon {
  const _MockBeacon({
    required this.uuid,
    required this.major,
    required this.minor,
    required this.baseRssi,
    required this.txPower,
  });

  final String uuid;
  final int major;
  final int minor;
  final int baseRssi;
  final int txPower;
}
