import 'package:equatable/equatable.dart';
import 'package:ibeacon_wrapper/ibeacon_wrapper.dart';

import '../../domain/entities/beacon_device.dart';

sealed class BeaconScannerEvent extends Equatable {
  const BeaconScannerEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class BeaconScannerInitializeRequested extends BeaconScannerEvent {
  const BeaconScannerInitializeRequested();
}

class BeaconScannerStartRequested extends BeaconScannerEvent {
  const BeaconScannerStartRequested();
}

class BeaconScannerStopRequested extends BeaconScannerEvent {
  const BeaconScannerStopRequested();
}

class BeaconScannerLifecycleChanged extends BeaconScannerEvent {
  const BeaconScannerLifecycleChanged({required this.isBackground});

  final bool isBackground;

  @override
  List<Object?> get props => <Object?>[isBackground];
}

class BeaconScannerRefreshRequested extends BeaconScannerEvent {
  const BeaconScannerRefreshRequested();
}

class BeaconDevicesUpdatedInternal extends BeaconScannerEvent {
  const BeaconDevicesUpdatedInternal(this.beacons);

  final List<BeaconDevice> beacons;

  @override
  List<Object?> get props => <Object?>[beacons];
}

class ScannerStatusUpdatedInternal extends BeaconScannerEvent {
  const ScannerStatusUpdatedInternal(this.status);

  final ScannerStatus status;

  @override
  List<Object?> get props => <Object?>[status];
}
