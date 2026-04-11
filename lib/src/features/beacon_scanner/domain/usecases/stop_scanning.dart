import '../repositories/beacon_repository.dart';

class StopScanning {
  const StopScanning(this._repository);

  final BeaconRepository _repository;

  Future<void> call() => _repository.stopScanning();
}
