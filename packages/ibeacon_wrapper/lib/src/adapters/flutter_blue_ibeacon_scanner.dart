import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../contracts/ibeacon_scanner.dart';
import '../entities/beacon_signal.dart';
import '../entities/scanner_status.dart';
import '../utils/ibeacon_packet_parser.dart';

class FlutterBlueIBeaconScanner implements IBeaconScanner {
  FlutterBlueIBeaconScanner({
    this.scanRestartInterval = const Duration(seconds: 15),
  });

  static const Duration _permissionRequestTimeout = Duration(seconds: 8);

  final Duration scanRestartInterval;

  final StreamController<List<BeaconSignal>> _beaconController =
      StreamController<List<BeaconSignal>>.broadcast();
  final StreamController<ScannerStatus> _statusController =
      StreamController<ScannerStatus>.broadcast();

  StreamSubscription<List<ScanResult>>? _scanSubscription;
  StreamSubscription<BluetoothAdapterState>? _adapterSubscription;
  Timer? _scanKeepAliveTimer;

  bool _initialized = false;
  bool _scanning = false;

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

    final bool supported = await FlutterBluePlus.isSupported;
    if (!supported) {
      _statusController.add(ScannerStatus.unsupported);
      _initialized = true;
      return;
    }

    if (!kIsWeb && _isApplePlatform) {
      await FlutterBluePlus.setOptions(restoreState: true);
    }

    _adapterSubscription = FlutterBluePlus.adapterState.listen(
      _handleAdapterState,
      onError: (Object error, StackTrace stackTrace) {
        _statusController.add(ScannerStatus.error);
      },
    );

    final bool permissionGranted = await _hasRequiredPermissions();
    if (!permissionGranted) {
      _statusController.add(ScannerStatus.permissionDenied);
      _initialized = true;
      return;
    }

    final ScannerStatus status = await _determineReadyStatus();
    _statusController.add(status);
    _initialized = true;
  }

  @override
  Future<void> requestPermissions() async {
    final bool granted = await _ensurePermissions();
    _statusController.add(
      granted ? await _determineReadyStatus() : ScannerStatus.permissionDenied,
    );
  }

  @override
  Future<void> start() async {
    if (!_initialized) {
      await initialize();
    }

    final bool permissionsGranted = await _hasRequiredPermissions();
    if (!permissionsGranted) {
      _statusController.add(ScannerStatus.permissionDenied);
      return;
    }

    final bool locationEnabled = await _isLocationServiceEnabled();
    if (!locationEnabled) {
      _statusController.add(ScannerStatus.locationOff);
      return;
    }

    final BluetoothAdapterState adapterState =
        await FlutterBluePlus.adapterState.first;
    if (adapterState != BluetoothAdapterState.on) {
      _statusController.add(ScannerStatus.bluetoothOff);
      return;
    }

    _scanSubscription ??= FlutterBluePlus.onScanResults.listen(
      _handleScanResults,
      onError: (Object error, StackTrace stackTrace) {
        _handleScanError(error);
      },
    );

    try {
      await FlutterBluePlus.startScan(
        continuousUpdates: true,
        androidUsesFineLocation: true,
        androidCheckLocationServices: true,
      );
      _scanning = true;
      _statusController.add(ScannerStatus.scanning);
      _startScanKeepAlive();
    } catch (error) {
      _handleScanError(error);
    }
  }

  @override
  Future<void> stop() async {
    _scanKeepAliveTimer?.cancel();
    _scanKeepAliveTimer = null;

    try {
      if (FlutterBluePlus.isScanningNow) {
        await FlutterBluePlus.stopScan();
      }
    } finally {
      _scanning = false;
      _statusController.add(ScannerStatus.stopped);
    }
  }

  @override
  Future<void> dispose() async {
    await stop();
    await _scanSubscription?.cancel();
    await _adapterSubscription?.cancel();
    await _beaconController.close();
    await _statusController.close();
  }

  Future<ScannerStatus> _determineReadyStatus() async {
    if (!await _isLocationServiceEnabled()) {
      return ScannerStatus.locationOff;
    }

    final BluetoothAdapterState adapterState =
        await FlutterBluePlus.adapterState.first;
    if (adapterState != BluetoothAdapterState.on) {
      return ScannerStatus.bluetoothOff;
    }

    return _scanning ? ScannerStatus.scanning : ScannerStatus.ready;
  }

  Future<bool> _ensurePermissions() async {
    if (kIsWeb) {
      return true;
    }

    if (_isAndroidPlatform) {
      late final Map<Permission, PermissionStatus> firstRound;
      try {
        firstRound = await <Permission>[
          Permission.bluetoothScan,
          Permission.bluetoothConnect,
          Permission.locationWhenInUse,
        ].request();
      } catch (_) {
        return false;
      }

      final bool firstRoundGranted =
          _isGranted(firstRound[Permission.bluetoothScan]) &&
          _isGranted(firstRound[Permission.bluetoothConnect]) &&
          _isGranted(firstRound[Permission.locationWhenInUse]);
      if (!firstRoundGranted) {
        return false;
      }

      return _requestBackgroundLocationPermission();
    }

    if (_isApplePlatform) {
      late final Map<Permission, PermissionStatus> firstRound;
      try {
        firstRound = await <Permission>[
          Permission.bluetooth,
          Permission.locationWhenInUse,
        ].request();
      } catch (_) {
        return false;
      }

      final bool firstRoundGranted =
          _isGranted(firstRound[Permission.bluetooth]) &&
          _isGranted(firstRound[Permission.locationWhenInUse]);
      if (!firstRoundGranted) {
        return false;
      }

      return _requestBackgroundLocationPermission();
    }

    return true;
  }

  Future<bool> _hasRequiredPermissions() async {
    if (kIsWeb) {
      return true;
    }

    if (_isAndroidPlatform) {
      final PermissionStatus scan = await Permission.bluetoothScan.status;
      final PermissionStatus connect = await Permission.bluetoothConnect.status;
      final PermissionStatus always = await Permission.locationAlways.status;
      return _isGranted(scan) && _isGranted(connect) && _isGranted(always);
    }

    if (_isApplePlatform) {
      final PermissionStatus bluetooth = await Permission.bluetooth.status;
      final PermissionStatus always = await Permission.locationAlways.status;
      return _isGranted(bluetooth) && _isGranted(always);
    }

    return true;
  }

  Future<bool> _isLocationServiceEnabled() async {
    if (kIsWeb) {
      return true;
    }

    final ServiceStatus serviceStatus =
        await Permission.locationWhenInUse.serviceStatus;
    return serviceStatus.isEnabled;
  }

  bool _isGranted(PermissionStatus? status) {
    if (status == null) {
      return false;
    }
    return status.isGranted || status.isLimited;
  }

  Future<bool> _requestBackgroundLocationPermission() async {
    try {
      final PermissionStatus current = await Permission.locationAlways.status;
      if (_isGranted(current)) {
        return true;
      }

      final PermissionStatus requested = await Permission.locationAlways
          .request()
          .timeout(_permissionRequestTimeout, onTimeout: () => current);
      return _isGranted(requested);
    } catch (_) {
      return false;
    }
  }

  bool get _isAndroidPlatform =>
      defaultTargetPlatform == TargetPlatform.android;

  bool get _isApplePlatform =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  void _startScanKeepAlive() {
    _scanKeepAliveTimer?.cancel();
    _scanKeepAliveTimer = Timer.periodic(scanRestartInterval, (
      Timer timer,
    ) async {
      if (!_scanning || FlutterBluePlus.isScanningNow) {
        return;
      }

      try {
        await FlutterBluePlus.startScan(
          continuousUpdates: true,
          androidUsesFineLocation: true,
          androidCheckLocationServices: true,
        );
      } catch (_) {
        _statusController.add(ScannerStatus.error);
      }
    });
  }

  void _handleAdapterState(BluetoothAdapterState state) {
    switch (state) {
      case BluetoothAdapterState.on:
        _statusController.add(
          _scanning ? ScannerStatus.scanning : ScannerStatus.ready,
        );
        return;
      case BluetoothAdapterState.unauthorized:
        _statusController.add(ScannerStatus.permissionDenied);
        return;
      case BluetoothAdapterState.off:
      case BluetoothAdapterState.turningOff:
      case BluetoothAdapterState.unavailable:
        _statusController.add(ScannerStatus.bluetoothOff);
        return;
      case BluetoothAdapterState.turningOn:
      case BluetoothAdapterState.unknown:
        _statusController.add(ScannerStatus.initializing);
        return;
    }
  }

  void _handleScanResults(List<ScanResult> results) {
    final Map<String, BeaconSignal> signalsById = <String, BeaconSignal>{};

    for (final ScanResult result in results) {
      final ParsedIBeaconPacket? parsed = IBeaconPacketParser.parse(
        result.advertisementData.manufacturerData,
      );
      if (parsed == null) {
        continue;
      }

      final BeaconSignal signal = BeaconSignal(
        uuid: parsed.uuid,
        major: parsed.major,
        minor: parsed.minor,
        rssi: result.rssi,
        txPower: parsed.txPower,
        timestamp: result.timeStamp,
      );

      final BeaconSignal? previous = signalsById[signal.beaconId];
      if (previous == null || signal.rssi > previous.rssi) {
        signalsById[signal.beaconId] = signal;
      }
    }

    if (signalsById.isNotEmpty) {
      final List<BeaconSignal> values = signalsById.values.toList()
        ..sort((BeaconSignal a, BeaconSignal b) => b.rssi.compareTo(a.rssi));
      _beaconController.add(values);
    }
  }

  void _handleScanError(Object error) {
    final String message = error.toString().toLowerCase();
    if (message.contains('permission')) {
      _statusController.add(ScannerStatus.permissionDenied);
      return;
    }

    if (message.contains('location')) {
      _statusController.add(ScannerStatus.locationOff);
      return;
    }

    _statusController.add(ScannerStatus.error);
  }
}
