import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ibeacon_wrapper/ibeacon_wrapper.dart';

import '../../../../core/services/local_notification_service.dart';
import '../../domain/entities/beacon_device.dart';
import '../../domain/usecases/initialize_scanner.dart';
import '../../domain/usecases/observe_beacons.dart';
import '../../domain/usecases/observe_scanner_status.dart';
import '../../domain/usecases/start_scanning.dart';
import '../../domain/usecases/stop_scanning.dart';
import 'beacon_scanner_event.dart';
import 'beacon_scanner_state.dart';

class BeaconScannerBloc extends Bloc<BeaconScannerEvent, BeaconScannerState> {
  BeaconScannerBloc({
    required InitializeScanner initializeScanner,
    required ObserveBeacons observeBeacons,
    required ObserveScannerStatus observeScannerStatus,
    required StartScanning startScanning,
    required StopScanning stopScanning,
    required LocalNotificationService notificationService,
  }) : _initializeScanner = initializeScanner,
       _observeBeacons = observeBeacons,
       _observeScannerStatus = observeScannerStatus,
       _startScanning = startScanning,
       _stopScanning = stopScanning,
       _notificationService = notificationService,
       super(const BeaconScannerState.initial()) {
    on<BeaconScannerInitializeRequested>(_onInitializeRequested);
    on<BeaconScannerStartRequested>(_onStartRequested);
    on<BeaconScannerStopRequested>(_onStopRequested);
    on<BeaconScannerLifecycleChanged>(_onLifecycleChanged);
    on<BeaconScannerRefreshRequested>(_onRefreshRequested);
    on<BeaconDevicesUpdatedInternal>(_onBeaconDevicesUpdated);
    on<ScannerStatusUpdatedInternal>(_onScannerStatusUpdated);
  }

  final InitializeScanner _initializeScanner;
  final ObserveBeacons _observeBeacons;
  final ObserveScannerStatus _observeScannerStatus;
  final StartScanning _startScanning;
  final StopScanning _stopScanning;
  final LocalNotificationService _notificationService;

  StreamSubscription<List<BeaconDevice>>? _beaconSubscription;
  StreamSubscription<ScannerStatus>? _statusSubscription;
  final Set<String> _detectedInBackground = <String>{};

  Future<void> _onInitializeRequested(
    BeaconScannerInitializeRequested event,
    Emitter<BeaconScannerState> emit,
  ) async {
    emit(
      state.copyWith(status: BeaconScreenStatus.loading, clearMessage: true),
    );

    try {
      await _initializeScanner();

      await _beaconSubscription?.cancel();
      _beaconSubscription = _observeBeacons().listen(
        (List<BeaconDevice> beacons) =>
            add(BeaconDevicesUpdatedInternal(beacons)),
      );

      await _statusSubscription?.cancel();
      _statusSubscription = _observeScannerStatus().listen(
        (ScannerStatus status) => add(ScannerStatusUpdatedInternal(status)),
      );

      emit(
        state.copyWith(status: BeaconScreenStatus.stopped, clearMessage: true),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: BeaconScreenStatus.error,
          message: error.toString(),
        ),
      );
    }
  }

  Future<void> _onStartRequested(
    BeaconScannerStartRequested event,
    Emitter<BeaconScannerState> emit,
  ) async {
    try {
      await _startScanning();
    } catch (error) {
      emit(
        state.copyWith(
          status: BeaconScreenStatus.error,
          message: error.toString(),
        ),
      );
    }
  }

  Future<void> _onStopRequested(
    BeaconScannerStopRequested event,
    Emitter<BeaconScannerState> emit,
  ) async {
    try {
      await _stopScanning();
      emit(state.copyWith(status: BeaconScreenStatus.stopped));
    } catch (error) {
      emit(
        state.copyWith(
          status: BeaconScreenStatus.error,
          message: error.toString(),
        ),
      );
    }
  }

  void _onLifecycleChanged(
    BeaconScannerLifecycleChanged event,
    Emitter<BeaconScannerState> emit,
  ) {
    emit(state.copyWith(isInBackground: event.isBackground));
  }

  void _onRefreshRequested(
    BeaconScannerRefreshRequested event,
    Emitter<BeaconScannerState> emit,
  ) {
    add(const BeaconScannerStartRequested());
  }

  Future<void> _onBeaconDevicesUpdated(
    BeaconDevicesUpdatedInternal event,
    Emitter<BeaconScannerState> emit,
  ) async {
    await _maybeNotifyProximityEvents(
      previous: state.beacons,
      current: event.beacons,
      inBackground: state.isInBackground,
    );

    emit(state.copyWith(beacons: event.beacons, clearMessage: true));
  }

  Future<void> _onScannerStatusUpdated(
    ScannerStatusUpdatedInternal event,
    Emitter<BeaconScannerState> emit,
  ) async {
    if (event.status == state.rawScannerStatus) {
      return;
    }

    final BeaconScreenStatus mappedStatus = _mapStatus(event.status);
    String? message;

    if (event.status == ScannerStatus.bluetoothOff) {
      message = 'Bluetooth is turned off.';
      await _notificationService.show(
        id: 9001,
        title: 'Bluetooth Disabled',
        body: 'Scanning has stopped because Bluetooth was turned off mid-scan.',
      );
    } else if (event.status == ScannerStatus.permissionDenied) {
      message = 'Location Always and Bluetooth permissions are required.';
      await _notificationService.show(
        id: 9002,
        title: 'Location Access Required',
        body:
            "Background scanning requires 'Always Allow' location permissions.",
      );
    } else if (event.status == ScannerStatus.locationOff) {
      message = 'Location service is turned off.';
    } else if (event.status == ScannerStatus.unsupported) {
      message = 'BLE hardware is not supported on this device.';
    }

    emit(
      state.copyWith(
        status: mappedStatus,
        rawScannerStatus: event.status,
        message: message,
        clearMessage: message == null,
      ),
    );
  }

  BeaconScreenStatus _mapStatus(ScannerStatus status) {
    switch (status) {
      case ScannerStatus.initializing:
        return BeaconScreenStatus.loading;
      case ScannerStatus.ready:
      case ScannerStatus.stopped:
        return BeaconScreenStatus.stopped;
      case ScannerStatus.scanning:
        return BeaconScreenStatus.scanning;
      case ScannerStatus.bluetoothOff:
        return BeaconScreenStatus.bluetoothOff;
      case ScannerStatus.locationOff:
        return BeaconScreenStatus.locationOff;
      case ScannerStatus.permissionDenied:
        return BeaconScreenStatus.permissionDenied;
      case ScannerStatus.unsupported:
      case ScannerStatus.error:
        return BeaconScreenStatus.error;
    }
  }

  Future<void> _maybeNotifyProximityEvents({
    required List<BeaconDevice> previous,
    required List<BeaconDevice> current,
    required bool inBackground,
  }) async {
    final Map<String, BeaconDevice> previousById = <String, BeaconDevice>{
      for (final BeaconDevice beacon in previous) beacon.id: beacon,
    };

    for (final BeaconDevice beacon in current) {
      if (inBackground && !_detectedInBackground.contains(beacon.id)) {
        _detectedInBackground.add(beacon.id);
        await _notificationService.show(
          id: _stableNotificationId('bg-${beacon.id}'),
          title: 'New Beacon Found',
          body:
              "You are near '${beacon.name ?? beacon.id}'. Open the app for details.",
          payload: beacon.uuid,
        );
      }

      final BeaconDevice? previousBeacon = previousById[beacon.id];
      final bool currentlyWithinFiveMeters =
          beacon.distanceMeters > 0 && beacon.distanceMeters <= 5;
      final bool wasWithinFiveMeters =
          previousBeacon != null &&
          previousBeacon.distanceMeters > 0 &&
          previousBeacon.distanceMeters <= 5;

      if (currentlyWithinFiveMeters && !wasWithinFiveMeters) {
        await _notificationService.show(
          id: _stableNotificationId('threshold-5-${beacon.id}'),
          title: 'Proximity Alert',
          body: 'Welcome! You are now within 5 meters of the beacon.',
          payload: beacon.uuid,
        );
      }
    }
  }

  int _stableNotificationId(String input) {
    return input.hashCode & 0x7FFFFFFF;
  }

  @override
  Future<void> close() async {
    await _beaconSubscription?.cancel();
    await _statusSubscription?.cancel();
    return super.close();
  }
}
