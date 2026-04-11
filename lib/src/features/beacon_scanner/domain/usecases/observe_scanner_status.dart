import 'package:ibeacon_wrapper/ibeacon_wrapper.dart';

import '../repositories/beacon_repository.dart';

class ObserveScannerStatus {
  const ObserveScannerStatus(this._repository);

  final BeaconRepository _repository;

  Stream<ScannerStatus> call() => _repository.observeScannerStatus();
}
