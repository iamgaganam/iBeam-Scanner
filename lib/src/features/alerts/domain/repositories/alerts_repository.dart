import '../entities/proximity_alert.dart';

abstract class AlertsRepository {
  Future<List<ProximityAlert>> getAlerts();
}
