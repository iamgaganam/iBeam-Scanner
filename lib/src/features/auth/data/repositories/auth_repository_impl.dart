import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_data_source.dart';
import '../models/app_user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required FirebaseAuthDataSource dataSource})
    : _dataSource = dataSource;

  final FirebaseAuthDataSource _dataSource;

  @override
  Stream<AppUser?> authStateChanges() {
    return _dataSource.authStateChanges().map((user) {
      if (user == null) {
        return null;
      }

      return AppUserModel(
        id: user.uid,
        email: user.email,
        displayName: user.displayName,
      );
    });
  }

  @override
  Future<void> signInWithGoogle() => _dataSource.signInWithGoogle();

  @override
  Future<void> signInWithApple() => _dataSource.signInWithApple();

  @override
  Future<void> signOut() => _dataSource.signOut();
}
