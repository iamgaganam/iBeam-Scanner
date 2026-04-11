import '../entities/proximity_alert.dart';
import '../repositories/alerts_repository.dart';

class GetAlerts {
  const GetAlerts(this._repository);

  final AlertsRepository _repository;

  Future<List<ProximityAlert>> call() => _repository.getAlerts();
}
