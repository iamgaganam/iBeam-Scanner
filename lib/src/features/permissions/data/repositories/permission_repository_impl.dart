import '../../domain/entities/permission_snapshot.dart';
import '../../domain/repositories/permission_repository.dart';
import '../datasources/device_permission_data_source.dart';

class PermissionRepositoryImpl implements PermissionRepository {
  PermissionRepositoryImpl({required DevicePermissionDataSource dataSource})
    : _dataSource = dataSource;

  final DevicePermissionDataSource _dataSource;

  @override
  Future<PermissionSnapshot> getStatus() => _dataSource.getStatus();

  @override
  Future<PermissionSnapshot> requestRequiredPermissions() =>
      _dataSource.requestAll();
}
