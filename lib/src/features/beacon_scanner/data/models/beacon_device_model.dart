import '../../domain/entities/beacon_device.dart';

class BeaconDeviceModel extends BeaconDevice {
  const BeaconDeviceModel({
    required super.uuid,
    required super.major,
    required super.minor,
    required super.rssi,
    required super.smoothedRssi,
    required super.txPower,
    required super.distanceMeters,
    required super.updatedAt,
    super.name,
  });
}
