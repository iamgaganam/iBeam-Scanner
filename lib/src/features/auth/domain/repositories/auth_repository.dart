import '../entities/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();

  Future<void> signInWithGoogle();

  Future<void> signInWithApple();

  Future<void> signOut();
}
