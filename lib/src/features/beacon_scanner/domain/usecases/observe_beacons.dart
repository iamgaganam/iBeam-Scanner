import '../entities/beacon_device.dart';
import '../repositories/beacon_repository.dart';

class ObserveBeacons {
  const ObserveBeacons(this._repository);

  final BeaconRepository _repository;

  Stream<List<BeaconDevice>> call() => _repository.observeBeacons();
}
