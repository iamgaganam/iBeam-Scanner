import 'package:equatable/equatable.dart';

class BeaconDevice extends Equatable {
  const BeaconDevice({
    required this.uuid,
    required this.major,
    required this.minor,
    required this.rssi,
    required this.smoothedRssi,
    required this.txPower,
    required this.distanceMeters,
    required this.updatedAt,
    this.name,
  });

  final String uuid;
  final int major;
  final int minor;
  final int rssi;
  final int smoothedRssi;
  final int txPower;
  final double distanceMeters;
  final DateTime updatedAt;
  final String? name;

  String get id => '$uuid:$major:$minor';

  @override
  List<Object?> get props => <Object?>[
    uuid,
    major,
    minor,
    rssi,
    smoothedRssi,
    txPower,
    distanceMeters,
    updatedAt,
    name,
  ];
}
