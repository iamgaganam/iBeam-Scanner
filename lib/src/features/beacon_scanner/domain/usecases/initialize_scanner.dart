import '../repositories/beacon_repository.dart';

class InitializeScanner {
  const InitializeScanner(this._repository);

  final BeaconRepository _repository;

  Future<void> call() => _repository.initializeScanner();
}
