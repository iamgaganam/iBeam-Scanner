import '../repositories/beacon_repository.dart';

class StartScanning {
  const StartScanning(this._repository);

  final BeaconRepository _repository;

  Future<void> call() => _repository.startScanning();
}
