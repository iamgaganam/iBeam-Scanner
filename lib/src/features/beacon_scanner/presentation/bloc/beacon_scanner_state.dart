import 'package:equatable/equatable.dart';
import 'package:ibeacon_wrapper/ibeacon_wrapper.dart';

import '../../domain/entities/beacon_device.dart';

enum BeaconScreenStatus {
  initial,
  loading,
  scanning,
  stopped,
  permissionDenied,
  bluetoothOff,
  locationOff,
  error,
}

class BeaconScannerState extends Equatable {
  const BeaconScannerState({
    required this.status,
    required this.rawScannerStatus,
    required this.beacons,
    required this.isInBackground,
    this.message,
  });

  const BeaconScannerState.initial()
    : this(
        status: BeaconScreenStatus.initial,
        rawScannerStatus: ScannerStatus.initializing,
        beacons: const <BeaconDevice>[],
        isInBackground: false,
      );

  final BeaconScreenStatus status;
  final ScannerStatus rawScannerStatus;
  final List<BeaconDevice> beacons;
  final bool isInBackground;
  final String? message;

  int get activeNodes => beacons.length;

  int? get strongestRssi {
    if (beacons.isEmpty) {
      return null;
    }

    int strongest = beacons.first.smoothedRssi;
    for (final BeaconDevice beacon in beacons.skip(1)) {
      if (beacon.smoothedRssi > strongest) {
        strongest = beacon.smoothedRssi;
      }
    }
    return strongest;
  }

  BeaconScannerState copyWith({
    BeaconScreenStatus? status,
    ScannerStatus? rawScannerStatus,
    List<BeaconDevice>? beacons,
    bool? isInBackground,
    String? message,
    bool clearMessage = false,
  }) {
    return BeaconScannerState(
      status: status ?? this.status,
      rawScannerStatus: rawScannerStatus ?? this.rawScannerStatus,
      beacons: beacons ?? this.beacons,
      isInBackground: isInBackground ?? this.isInBackground,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => <Object?>[
    status,
    rawScannerStatus,
    beacons,
    isInBackground,
    message,
  ];
}
