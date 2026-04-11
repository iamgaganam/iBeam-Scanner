class BeaconSignal {
  const BeaconSignal({
    required this.uuid,
    required this.major,
    required this.minor,
    required this.rssi,
    required this.txPower,
    this.timestamp,
  });

  final String uuid;
  final int major;
  final int minor;
  final int rssi;
  final int txPower;
  final DateTime? timestamp;

  String get beaconId => '$uuid:$major:$minor';
}
