import '../entities/permission_snapshot.dart';
import '../repositories/permission_repository.dart';

class GetPermissionStatus {
  const GetPermissionStatus(this._repository);

  final PermissionRepository _repository;

  Future<PermissionSnapshot> call() => _repository.getStatus();
}
