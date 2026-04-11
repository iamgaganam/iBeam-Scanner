import 'dart:async';

import '../contracts/ibeacon_scanner.dart';
import '../entities/beacon_signal.dart';
import '../entities/scanner_status.dart';

class FailoverIBeaconScanner implements IBeaconScanner {
  FailoverIBeaconScanner({required this.primary, required this.fallback})
    : _active = primary;

  final IBeaconScanner primary;
  final IBeaconScanner fallback;

  IBeaconScanner _active;
  bool _usingFallback = false;

  final StreamController<List<BeaconSignal>> _beaconController =
      StreamController<List<BeaconSignal>>.broadcast();
  final StreamController<ScannerStatus> _statusController =
      StreamController<ScannerStatus>.broadcast();

  StreamSubscription<List<BeaconSignal>>? _beaconSubscription;
  StreamSubscription<ScannerStatus>? _statusSubscription;

  @override
  Stream<List<BeaconSignal>> get beaconStream => _beaconController.stream;

  @override
  Stream<ScannerStatus> get statusStream => _statusController.stream;

  @override
  Future<void> initialize() async {
    await _attachToScanner(_active);

    try {
      await _active.initialize();
    } catch (_) {
      await _switchToFallback();
    }
  }

  @override
  Future<void> requestPermissions() => _active.requestPermissions();

  @override
  Future<void> start() async {
    try {
      await _active.start();
    } catch (_) {
      await _switchToFallback();
      await _active.start();
    }
  }

  @override
  Future<void> stop() => _active.stop();

  @override
  Future<void> dispose() async {
    await _beaconSubscription?.cancel();
    await _statusSubscription?.cancel();

    await _active.dispose();
    if (_active != primary) {
      await primary.dispose();
    }
    if (_active != fallback) {
      await fallback.dispose();
    }

    await _beaconController.close();
    await _statusController.close();
  }

  Future<void> _attachToScanner(IBeaconScanner scanner) async {
    await _beaconSubscription?.cancel();
    await _statusSubscription?.cancel();

    _beaconSubscription = scanner.beaconStream.listen(
      _beaconController.add,
      onError: _beaconController.addError,
    );

    _statusSubscription = scanner.statusStream.listen((ScannerStatus status) {
      _statusController.add(status);
      if (!_usingFallback &&
          scanner == primary &&
          status == ScannerStatus.unsupported) {
        unawaited(_switchToFallback());
      }
    }, onError: _statusController.addError);
  }

  Future<void> _switchToFallback() async {
    if (_usingFallback) {
      return;
    }

    _usingFallback = true;
    _active = fallback;
    await _attachToScanner(_active);
    await _active.initialize();
    _statusController.add(ScannerStatus.ready);
  }
}
