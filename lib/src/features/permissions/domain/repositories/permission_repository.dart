import '../entities/permission_snapshot.dart';

abstract class PermissionRepository {
  Future<PermissionSnapshot> getStatus();

  Future<PermissionSnapshot> requestRequiredPermissions();
}
