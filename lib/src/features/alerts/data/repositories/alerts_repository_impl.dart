import '../../domain/entities/proximity_alert.dart';
import '../../domain/repositories/alerts_repository.dart';
import '../datasources/alerts_local_data_source.dart';

class AlertsRepositoryImpl implements AlertsRepository {
  AlertsRepositoryImpl({required AlertsLocalDataSource dataSource})
    : _dataSource = dataSource;

  final AlertsLocalDataSource _dataSource;

  @override
  Future<List<ProximityAlert>> getAlerts() => _dataSource.getAlerts();
}
