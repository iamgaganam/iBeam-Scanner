import 'package:ibeacon_wrapper/ibeacon_wrapper.dart';

import '../../domain/entities/beacon_device.dart';
import '../../domain/repositories/beacon_repository.dart';
import '../datasources/ibeacon_data_source.dart';
import '../models/beacon_device_model.dart';

class BeaconRepositoryImpl implements BeaconRepository {
  BeaconRepositoryImpl({required IBeaconDataSource dataSource})
    : _dataSource = dataSource;

  final IBeaconDataSource _dataSource;

  final Map<String, RssiMovingAverage> _movingAverageByBeacon =
      <String, RssiMovingAverage>{};

  static const Map<String, String> _knownBeaconNames = <String, String>{
    'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0': 'Conference Room B',
    'A1221100-3344-4BC2-A901-EE203344CC89': 'Private Office 4',
    'F4980120-E4F1-4E7B-9E33-0245648A044B': 'West Wing Lobby',
  };

  @override
  Stream<List<BeaconDevice>> observeBeacons() {
    return _dataSource.rawBeaconStream().map((List<BeaconSignal> rawSignals) {
      final List<BeaconDeviceModel> devices = rawSignals.map((
        BeaconSignal signal,
      ) {
        final RssiMovingAverage average = _movingAverageByBeacon.putIfAbsent(
          signal.beaconId,
          () => RssiMovingAverage(windowSize: 5),
        );
        final int smoothedRssi = average.add(signal.rssi);

        return BeaconDeviceModel(
          uuid: signal.uuid,
          major: signal.major,
          minor: signal.minor,
          rssi: signal.rssi,
          smoothedRssi: smoothedRssi,
          txPower: signal.txPower,
          distanceMeters: DistanceEstimator.estimateMeters(
            rssi: smoothedRssi,
            txPower: signal.txPower,
          ),
          updatedAt: signal.timestamp ?? DateTime.now(),
          name:
              _knownBeaconNames[signal.uuid] ??
              'Beacon ${signal.major}-${signal.minor}',
        );
      }).toList();

      devices.sort((BeaconDevice a, BeaconDevice b) {
        final double left = a.distanceMeters < 0 ? 9999 : a.distanceMeters;
        final double right = b.distanceMeters < 0 ? 9999 : b.distanceMeters;
        return left.compareTo(right);
      });

      return devices;
    });
  }

  @override
  Stream<ScannerStatus> observeScannerStatus() =>
      _dataSource.scannerStatusStream();

  @override
  Future<void> initializeScanner() => _dataSource.initialize();

  @override
  Future<void> startScanning() => _dataSource.start();

  @override
  Future<void> stopScanning() => _dataSource.stop();

  @override
  Future<void> dispose() => _dataSource.dispose();
}
