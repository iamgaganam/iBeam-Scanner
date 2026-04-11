import '../entities/permission_snapshot.dart';
import '../repositories/permission_repository.dart';

class RequestPermissions {
  const RequestPermissions(this._repository);

  final PermissionRepository _repository;

  Future<PermissionSnapshot> call() => _repository.requestRequiredPermissions();
}
